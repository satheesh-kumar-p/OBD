import 'dart:async';
import 'dart:typed_data';

import '../../logger/logger.dart';
import 'can_frame.dart';
import 'can_frame_parser.dart';
import 'can_service.dart';
import 'i_serial_transport.dart';
import 'can_config.dart';

/// Waveshare-specific implementation of [CanService].
class CanServiceImpl implements CanService {
  final ISerialTransport _transport;
  final CanFrameParser _parser;
  final Logger _logger;
  
  final StreamController<bool> _connectionCtrl = StreamController<bool>.broadcast();
  StreamSubscription<Uint8List>? _transportSub;

  CanServiceImpl({
    required ISerialTransport transport,
    required CanFrameParser parser,
    required Logger logger,
  })  : _transport = transport,
        _parser = parser,
        _logger = logger;

  @override
  Stream<CanFrame> get frameStream => _parser.frames;

  @override
  Stream<bool> get connectionStream => _connectionCtrl.stream;

  @override
  bool get isConnected => _transport.isConnected;

  @override
  Future<void> connect(
    String portName, {
    int baudRate = 2000000,
    required CanConfig config,
  }) async {
    try {
      _logger.info('Connecting to serial transport', context: {'port': portName, 'baud': baudRate});
      await _transport.connect(portName, baudRate: baudRate);
      _logger.info('Serial transport connected. Sending CAN configuration...');
      
      // Apply Waveshare handshake/config (Mandatory for Variable Length mode)
      await _transport.write(config.toCommandPacket());
      
      // Small delay for adapter to process the configuration
      await Future.delayed(const Duration(milliseconds: 100));

      _transportSub = _transport.dataStream.listen(
        _parser.feed,
        onError: (e, st) {
          _logger.error('Transport stream error', error: e, stack: st);
          _connectionCtrl.add(false);
        },
        onDone: () {
          _logger.warn('Transport stream closed');
          _connectionCtrl.add(false);
        },
      );

      _connectionCtrl.add(true);
    } catch (e, st) {
      _logger.error('Failed to establish CAN service connection', error: e, stack: st);
      _connectionCtrl.add(false);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    _logger.info('Disconnecting CAN service');
    await _transportSub?.cancel();
    _transportSub = null;
    await _transport.disconnect();
    _connectionCtrl.add(false);
  }

  @override
  Future<void> send(CanFrame frame) async {
    if (!isConnected) {
      _logger.warn('Cannot send CAN frame: not connected');
      return;
    }
    final bytes = CanFrameParser.serialize(frame);
    await _transport.write(bytes);
  }

  @override
  void dispose() {
    _logger.info('Disposing CAN service');
    disconnect();
    _parser.dispose();
    _connectionCtrl.close();
  }
}
