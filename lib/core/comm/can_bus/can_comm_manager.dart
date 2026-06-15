import 'dart:async';

import '../../dispatcher/message_dispatcher.dart';
import '../../logger/logger.dart';
import 'can_config.dart';
import 'can_frame.dart';
import 'i_can_service.dart';

/// Central manager for CAN communication.
/// Handles the lifecycle of a single [ICanService] connection.
class CanCommManager {
  CanCommManager({
    required ICanService service,
    required Logger logger,
    MessageDispatcher? dispatcher,
  })  : _service = service,
        _logger = logger,
        _dispatcher = dispatcher ?? MessageDispatcher() {
    _service.connectionStream.listen((connected) {
      _logger.info('CAN Connection Status: ${connected ? "CONNECTED" : "DISCONNECTED"}');
    });
  }

  final Logger _logger;
  final ICanService _service;
  final MessageDispatcher _dispatcher;
  StreamSubscription<CanFrame>? _frameSub;

  // A persistent controller so listeners can subscribe before connection
  final _frameController = StreamController<CanFrame>.broadcast();

  /// Stream of all incoming CAN frames (filtered/sampled by dispatcher).
  Stream<CanFrame> get frameStream => _dispatcher.frameStream;

  /// Stream of connection status.
  Stream<bool> get connectionStream => _service.connectionStream;

  /// Whether the service is currently connected.
  bool get isConnected => _service.isConnected;

  /// Initializes and connects to the CAN link using the mandatory [config].
  Future<void> connect({
    required String portName,
    int baudRate = 2000000,
    required CanConfig config,
  }) async {
    if (_service.isConnected) {
      _logger.warn('CommManager: Already connected, disconnecting first.');
      await disconnect();
    }

    _logger.info(
      'CommManager: Connecting to $portName',
      context: {'Serial baud': baudRate, 'Can Bus Baud Rate': config.baudRate},
    );

    try {
      await _service.connect(portName, baudRate: baudRate, config: config);

      // Pipe the service frames into our dispatcher
      _frameSub = _service.frameStream.listen(
        _dispatcher.dispatch,
        onError: (e, st) => _logger.error('Dispatcher input error', error: e, stack: st),
      );

      _logger.info('CommManager: Successfully connected');
    } catch (e, st) {
      _logger.error('CommManager: Connection failed', error: e, stack: st);
      rethrow;
    }
  }

  /// Disconnects the current CAN link and cleans up resources.
  Future<void> disconnect() async {
    _logger.info('CommManager: Disconnecting');
    await _frameSub?.cancel();
    _frameSub = null;
    await _service.disconnect();
  }

  /// Returns a filtered stream of frames with a specific [messageId].
  Stream<CanFrame> watchMessage(int messageId) {
    return frameStream.where((frame) => frame.id == messageId);
  }

  /// Sends a [CanFrame] to the CAN bus.
  Future<void> send(CanFrame frame) async {
    if (!_service.isConnected) {
      _logger.warn('CommManager: Cannot send, service not connected');
      return;
    }
    await _service.send(frame);
  }

  /// Disposes of the manager and any active connections.
  void dispose() {
    disconnect();
    _frameController.close();
    _dispatcher.dispose();
    _service.dispose();
  }
}
