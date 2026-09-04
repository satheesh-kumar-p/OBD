import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dispatcher/message_dispatcher.dart';
import '../comm/comm_manager.dart';
import '../comm/checksum/checksum_packet.dart';
import '../constants/app_constants.dart';
import '../logger/logger.dart';

/// High-level communication manager.
final commManagerLoggerProvider = Provider<Logger>(
  (ref) => Logger('COMM_MANAGER'),
);

final commDispatcherProvider = Provider<MessageDispatcher>((ref) {
  return MessageDispatcher(
    configs: AppConstants.dispatchConfigs,
    whitelist: AppConstants.whitelistedMessageIds,
    staleThreshold: AppConstants.staleThreshold,
  );
});

final commManagerProvider = Provider<CommManager>((ref) {
  final manager = CommManager(
    transportType: AppConstants.transportType,
    logger: ref.read(commManagerLoggerProvider),
    dispatcher: ref.read(commDispatcherProvider),
  );

  ref.onDispose(() => manager.dispose());
  return manager;
});

/// Brings up the single UDP socket (port 5005) that now carries both CAN
/// frames and checksum/version JSON heartbeats, demultiplexed inside
/// CommManager by first-byte inspection.
final commConnectionProvider = FutureProvider<void>((ref) async {
  final manager = ref.read(commManagerProvider);
  final logger = ref.read(commManagerLoggerProvider);

  try {
    await manager.connect();
  } catch (e, st) {
    logger.error(
      'Failed to establish communication connection',
      error: e,
      stack: st,
    );
    rethrow;
  }
});

/// Checksum/version heartbeat packets, demultiplexed out of the shared
/// CAN socket (port 5005) inside CommManager — see
/// CommManager._routeIncomingData for how CAN vs checksum bytes are
/// told apart on the one socket.
final checksumPacketsProvider = StreamProvider<ChecksumPacket>((ref) {
  final manager = ref.read(commManagerProvider);
  // Ensure the shared socket is being brought up if nothing else already
  // triggered commConnectionProvider.
  return manager.checksumDataStream;
});

/// Provides a ticker that emits every second to refresh time-dependent UI.
final clockTickerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (tick) => tick);
});