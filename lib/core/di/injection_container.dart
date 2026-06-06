import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mavlink_module/dialects/ugvcustom.dart';

import '../comm/can_bus/can_bus.dart';
import '../comm/comm_link_config.dart';
import '../comm/comm_manager.dart';
import '../constants/app_constants.dart';
import '../enums/can_enums.dart';
import '../enums/transport_type.dart';
import '../logger/logger.dart';

/*
final commManagerProvider = Provider<CommManager>((ref) {
  final logger = Logger("COMM_MANAGER");

  final manager = CommManager(
      dialect: MavlinkDialectUgvcustom(), logger: logger);

  manager.addLink(const CommLinkConfig(
      id: AppConstants.primaryLinkId,
      transportType: TransportType.udp,
      host: AppConstants.mavlinkHost,
      port: AppConstants.mavlinkPort));

  ref.onDispose(manager.disconnectAll);
  return manager;
});

final commConnectionProvider = FutureProvider<void>((ref) async {
  final manager = ref.read(commManagerProvider);
  final logger = Logger('COMM_CONNECTION');

  try {
    await manager.connectAll();
  } catch (e) {
    logger.error(
      'Exception in Comm connection',
      context: {'error': e.toString()},
    );
  }
});
*/

/// Raw transport layer provider.
final serialLoggerProvider = Provider<Logger>((ref) => Logger('SERIAL'));
final serialTransportProvider = Provider<ISerialTransport>((ref) => SerialPortTransport(logger: ref.read(serialLoggerProvider)));

/// Concrete implementation of the CAN service.
final canServiceLoggerProvider = Provider<Logger>((ref) => Logger('CAN_SERVICE'));
final canServiceProvider = Provider<CanService>((ref) {
  final logger = ref.read(canServiceLoggerProvider);

  if (AppConstants.useMockBackends) {
    return MockCanService(logger);
  }

  return CanServiceImpl(
    transport: ref.read(serialTransportProvider),
    parser: CanFrameParser(),
    logger: logger,
  );
});

/// High-level communication manager.
final canManagerLoggerProvider = Provider<Logger>((ref) => Logger('CAN_MANAGER'));
final canManagerProvider = Provider<CanCommManager>((ref) {
  return CanCommManager(
    service: ref.read(canServiceProvider),
    logger: ref.read(canManagerLoggerProvider),
  );
});

/// FutureProvider that handles the initial connection handshake.
final canConnectionProvider = FutureProvider<void>((ref) async {
  final manager = ref.read(canManagerProvider);
  final logger = ref.read(canManagerLoggerProvider);

  try {
    // Port and config can be adjusted for your specific setup
    await manager.connect(
      portName: AppConstants.canPortName,
      config: const CanConfig(baudRate: AppConstants.canBaudRate),
    );
  } catch (e, st) {
    logger.error('Failed to establish CAN connection', error: e, stack: st);
    rethrow;
  }
});
