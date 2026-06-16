import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dispatcher/message_dispatcher.dart';
import '../comm/comm_manager.dart';
import '../constants/app_constants.dart';
import '../logger/logger.dart';
import '../comm/can_bus/can_frame.dart';

/// High-level communication manager.
final commManagerLoggerProvider = Provider<Logger>((ref) => Logger('COMM_MANAGER'));

final commDispatcherProvider = Provider<MessageDispatcher>((ref) {
  return MessageDispatcher(
    configs: AppConstants.dispatchConfigs,
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

/// FutureProvider that handles the initial connection handshake.
final commConnectionProvider = FutureProvider<void>((ref) async {
  final manager = ref.read(commManagerProvider);
  final logger = ref.read(commManagerLoggerProvider);

  try {
    await manager.connect();
  } catch (e, st) {
    logger.error('Failed to establish communication connection', error: e, stack: st);
    rethrow;
  }
});

/// Provides the raw CAN frame stream for debugging.
final commFrameStreamProvider = StreamProvider<CanFrame>((ref) {
  final manager = ref.watch(commManagerProvider);
  return manager.frameStream;
});

/// Provides a ticker that emits every second to refresh time-dependent UI.
final clockTickerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (tick) => tick);
});

/// Provides a ticker that emits every 5 seconds for efficiency-minded staleness checks.
final stalenessTickerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 5), (tick) => tick);
});
