import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../comm/can_bus/can_bus.dart';
import '../comm/can_bus/can_dispatch_configs.dart';
import '../comm/can_bus/can_dispatcher.dart';
import '../constants/app_constants.dart';
import '../logger/logger.dart';

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
final canDispatcherProvider = Provider<CanMessageDispatcher>((ref) {
  return CanMessageDispatcher(
    configs: CanDispatchConfigs.defaultConfigs,
  );
});

final canManagerProvider = Provider<CanCommManager>((ref) {
  return CanCommManager(
    service: ref.read(canServiceProvider),
    logger: ref.read(canManagerLoggerProvider),
    dispatcher: ref.read(canDispatcherProvider),
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
