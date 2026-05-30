import 'dart:async';
import 'dart:typed_data';
import '../../enums/can_enums.dart';
import '../../logger/logger.dart';
import 'can_frame.dart';
import 'can_service.dart';
import 'can_config.dart';

/// Mock CAN service that emits fake frames.
/// Matches the architecture of MockMavlinkService.
class MockCanService implements CanService {
  final Logger _logger;
  final _frameCtrl = StreamController<CanFrame>.broadcast();
  final _connectionCtrl = StreamController<bool>.broadcast();

  bool _connected = false;
  Timer? _periodicTimer;

  MockCanService({required Logger logger}) : _logger = logger;

  @override
  Stream<CanFrame> get frameStream => _frameCtrl.stream;

  @override
  Stream<bool> get connectionStream => _connectionCtrl.stream;

  @override
  bool get isConnected => _connected;

  @override
  Future<void> connect(String portName, {int baudRate = 2000000, required CanConfig config}) async {
    if (_connected) return;

    _logger.info('MockCanService: Connecting to $portName (Mock)...');
    await Future.delayed(const Duration(milliseconds: 500));

    _connected = true;
    _connectionCtrl.add(true);
    _logger.info('MockCanService: Connected.');

    // Start emitting fake robot data (e.g. System Info 0x203, Drive Info 0x204)
    _periodicTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_connected) return;
      _emitSystemInfo();
      _emitDriveInfo();
    });
  }

  @override
  Future<void> disconnect() async {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _connected = false;
    _connectionCtrl.add(false);
    _logger.info('MockCanService: Disconnected.');
  }

  @override
  Future<void> send(CanFrame frame) async {
    _logger.debug('MockCanService: Sending Frame $frame');
  }

  @override
  void dispose() {
    disconnect();
    _frameCtrl.close();
    _connectionCtrl.close();
  }

  /// Helper to set bits in a payload
  void _setBits(Uint8List data, int startBit, int length, int value) {
    for (int i = 0; i < length; i++) {
      int bitPos = startBit + i;
      int byteIdx = bitPos ~/ 8;
      int bitIdx = bitPos % 8;

      if (byteIdx >= data.length) break;

      // Clear the bit
      data[byteIdx] &= ~(1 << bitIdx);
      // Set the bit if value has it
      if (((value >> i) & 0x01) == 1) {
        data[byteIdx] |= (1 << bitIdx);
      }
    }
  }

  void _emitSystemInfo() {
    final data = Uint8List(8);
    
    // Time fields (0-16) - set to some dummy time 12:34:56
    _setBits(data, 0, 5, 12);  // hour
    _setBits(data, 5, 6, 34);  // minute
    _setBits(data, 11, 6, 56); // second

    // User requirements:
    // motor controllers: 1 (no communication)
    _setBits(data, 17, 2, 1); // rear MC
    _setBits(data, 19, 2, 1); // front MC

    // hv battery: healthy (2)
    _setBits(data, 21, 2, 2);

    // lv battery: unhealthy (3)
    _setBits(data, 23, 2, 3);

    // dc48: healthy (2)
    _setBits(data, 27, 2, 2);

    // dc12: unhealthy (3)
    _setBits(data, 29, 2, 3);

    // VCU: unhealthy (3)
    _setBits(data, 31, 2, 3);

    // Others: healthy (2)
    _setBits(data, 25, 2, 2); // LV PDU
    _setBits(data, 33, 2, 2); // FL Motor
    _setBits(data, 35, 2, 2); // RL Motor
    _setBits(data, 37, 2, 2); // FR Motor
    _setBits(data, 39, 2, 2); // RR Motor

    _frameCtrl.add(CanFrame(
      id: 0x203,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitDriveInfo() {
    final data = Uint8List(8);

    // Dummy time
    _setBits(data, 0, 5, 12);
    _setBits(data, 5, 6, 34);
    _setBits(data, 11, 6, 56);

    // Front Left Motor: bits 33-40 -> 33 (overSpeed(1) | overTemp(32))
    _setBits(data, 33, 8, 33);

    // Left MC: bits 56-61 -> 2 (overCurrent(2))
    _setBits(data, 56, 6, 2);

    // All others 0 (Healthy)

    _frameCtrl.add(CanFrame(
      id: 0x204,
      idType: CanIdType.standard,
      data: data,
    ));
  }
}
