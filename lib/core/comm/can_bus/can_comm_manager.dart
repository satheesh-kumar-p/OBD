import 'dart:async';

import '../../logger/logger.dart';
import 'can_config.dart';
import 'can_frame.dart';
import 'can_service.dart';

/// Central manager for CAN communication.
/// Handles the lifecycle of a single [CanService] connection.
class CanCommManager {
  CanCommManager({required CanService service, required Logger logger})
      : _service = service,
        _logger = logger;

  final Logger _logger;
  final CanService _service;
  StreamSubscription<CanFrame>? _frameSub;

  // A persistent controller so listeners can subscribe before connection
  final _frameController = StreamController<CanFrame>.broadcast();

  /// Stream of all incoming CAN frames.
  Stream<CanFrame> get frameStream => _frameController.stream;

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
      context: {'baud': baudRate},
    );

    try {
      await _service.connect(portName, baudRate: baudRate, config: config);

      // Pipe the service frames into our central controller
      _frameSub = _service.frameStream.listen(
        _frameController.add,
        onError: _frameController.addError,
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
    _service.dispose();
  }
}
