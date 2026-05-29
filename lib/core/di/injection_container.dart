import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mavlink_module/dialects/ugvcustom.dart';

import '../comm/can_bus/can_bus.dart';
import '../comm/comm_link_config.dart';
import '../comm/comm_manager.dart';
import '../constants/app_constants.dart';
import '../enums/can_enums.dart';
import '../enums/transport_type.dart';
import '../logger/logger.dart';

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

/// Raw transport layer provider.
final serialTransportProvider = Provider<ISerialTransport>((ref) => SerialPortTransport());

/// Concrete implementation of the CAN service.
final canServiceProvider = Provider<CanService>((ref) => CanServiceImpl(
  transport: ref.read(serialTransportProvider),
  parser: CanFrameParser(),
));

/// High-level communication manager.
final canManagerProvider = Provider<CanCommManager>((ref) {
  final logger = Logger("COMM_MANAGER");
  return CanCommManager(
    service: ref.read(canServiceProvider),
    logger: logger,
  );
});

/// FutureProvider that handles the initial connection handshake.
final canConnectionProvider = FutureProvider<void>((ref) async {
  final manager = ref.read(canManagerProvider);
  final logger = Logger('CAN_MANAGER');

  try {
    // Port and config can be adjusted for your specific setup
    await manager.connect(
      portName: '/dev/can',
      config: const CanConfig(baudRate: CanBaudRate.bps500k),
    );
  } catch (e, st) {
    logger.error('Failed to establish CAN connection', error: e, stack: st);
    rethrow;
  }
});
