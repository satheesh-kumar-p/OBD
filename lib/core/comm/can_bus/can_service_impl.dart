import 'dart:async';
import 'dart:typed_data';

import 'can_frame.dart';
import 'can_frame_parser.dart';
import 'can_service.dart';
import 'i_serial_transport.dart';
import 'can_config.dart';

/// Waveshare-specific implementation of [CanService].
class CanServiceImpl implements CanService {
  final ISerialTransport _transport;
  final CanFrameParser _parser;
  
  final StreamController<bool> _connectionCtrl = StreamController<bool>.broadcast();
  StreamSubscription<Uint8List>? _transportSub;

  CanServiceImpl({
    required ISerialTransport transport,
    required CanFrameParser parser,
  })  : _transport = transport,
        _parser = parser;

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
      await _transport.connect(portName, baudRate: baudRate);
      print('[CanService] Serial connection established. Sending CAN configuration...');
      
      // Apply Waveshare handshake/config (Mandatory for Variable Length mode)
      await _transport.write(config.toCommandPacket());
      
      // Small delay for adapter to process the configuration
      await Future.delayed(const Duration(milliseconds: 100));

      _transportSub = _transport.dataStream.listen(
        _parser.feed,
        onError: (e) => _connectionCtrl.add(false),
        onDone: () => _connectionCtrl.add(false),
      );

      _connectionCtrl.add(true);
    } catch (e) {
      _connectionCtrl.add(false);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _transportSub?.cancel();
    _transportSub = null;
    await _transport.disconnect();
    _connectionCtrl.add(false);
  }

  @override
  Future<void> send(CanFrame frame) async {
    if (!isConnected) return;
    final bytes = CanFrameParser.serialize(frame);
    await _transport.write(bytes);
  }

  @override
  void dispose() {
    disconnect();
    _parser.dispose();
    _connectionCtrl.close();
  }
}
