import 'dart:async';
import 'dart:typed_data';
import '../../enums/can_enums.dart';
import '../../logger/logger.dart';
import 'can_frame.dart';
import 'i_can_service.dart';
import 'can_config.dart';

/// Mock CAN service that emits fake frames.
/// Matches the architecture of MockMavlinkService.
class MockCanService implements ICanService {
  final Logger _logger;
  final _frameCtrl = StreamController<CanFrame>.broadcast();
  final _connectionCtrl = StreamController<bool>.broadcast();

  bool _connected = false;
  Timer? _periodicTimer;

  MockCanService(Logger logger) : _logger = logger;

  @override
  Stream<CanFrame> get frameStream => _frameCtrl.stream;

  @override
  Stream<bool> get connectionStream => _connectionCtrl.stream;

  @override
  bool get isConnected => _connected;

  @override
  Future<void> connect(String portName, {int baudRate = 2000000, required CanConfig config}) async {
    if (_connected) return;

    _logger.info('MockCanService: Connecting to $portName (Mock)...', context: {
      'serial_baud': baudRate,
      'can_bus_speed': config.baudRate.name,
    });
    await Future.delayed(const Duration(milliseconds: 500));

    _connected = true;
    _connectionCtrl.add(true);
    _logger.info('MockCanService: Connected.');

    // Start emitting fake robot data (e.g. System Info 0x203, Drive Info 0x204)
    _periodicTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_connected) return;
      _emitSystemInfo();
      _emitDriveInfo();
      _emitBatteryInfo();
      _emitModeInfo();
      _emitGlobalTimeInfo();
      _emitCompTimeSync();
      _emitComputeCommInfo();
      _emitEStopInfo();
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

  /// Helper to set bits in a payload (Big Endian - MSB at Bit 0)
  void _setBits(Uint8List data, int startBit, int length, int value) {
    for (int i = 0; i < length; i++) {
      int bitPos = startBit + i;
      int byteIdx = bitPos ~/ 8;
      // MSB at bit 0 means index 0 is bit 7 in standard shifting
      int bitIdx = 7 - (bitPos % 8);

      if (byteIdx >= data.length) break;

      // Clear the bit
      data[byteIdx] &= ~(1 << bitIdx);
      // Set the bit if value has it at corresponding significance (startBit is MSB)
      if (((value >> (length - 1 - i)) & 0x01) == 1) {
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

  void _emitEStopInfo() {
    final data = Uint8List(8);
    _setBits(data, 17, 1, 1);

    _frameCtrl.add(CanFrame(
      id: 0x201,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitBatteryInfo() {
    final data = Uint8List(8);

    // Dummy time
    _setBits(data, 0, 5, 12);
    _setBits(data, 5, 6, 34);
    _setBits(data, 11, 6, 56);

    // SOC: 85% (bits 17-24)
    _setBits(data, 17, 8, 85);

    // Voltage: 24.5V -> 24 (bits 25-32)
    // 8 bits max is 255. 24 results in 24V with ~/10 transformer.
    _setBits(data, 25, 8, 24);

    _frameCtrl.add(CanFrame(
      id: 0x200,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitModeInfo() {
    final data = Uint8List(8);

    // Dummy time (0-16)
    _setBits(data, 0, 5, 12);
    _setBits(data, 5, 6, 34);
    _setBits(data, 11, 6, 56);

    // MainMode: modeA (1) bits 17-20
    _setBits(data, 17, 4, 1);

    // SubMode: none (0) bits 21-24
    _setBits(data, 21, 4, 0);

    // SpeedMode: medium (2) bits 25-28
    _setBits(data, 25, 4, 2);

    // DriveMode: speed (1) bits 29-32
    _setBits(data, 29, 4, 1);

    // Armed: true (1) bit 33
    _setBits(data, 33, 1, 1);

    // Headlights: true (1) bit 34
    _setBits(data, 34, 1, 1);

    // FogLights: false (0) bit 35
    _setBits(data, 35, 1, 0);

    // BrakeLights: false (0) bit 36
    _setBits(data, 36, 1, 0);

    _frameCtrl.add(CanFrame(
      id: 0x20B,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitGlobalTimeInfo() {
    final data = Uint8List(8);
    final now = DateTime.now();

    // Year offset from 2000 (0-6)
    _setBits(data, 0, 7, now.year - 2000);
    // Month (7-10)
    _setBits(data, 7, 4, now.month);
    // Date (11-15)
    _setBits(data, 11, 5, now.day);
    // Hour (16-20)
    _setBits(data, 16, 5, now.hour);
    // Minute (21-26)
    _setBits(data, 21, 6, now.minute);
    // Second (27-32)
    _setBits(data, 27, 6, now.second);

    _frameCtrl.add(CanFrame(
      id: 0x202,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitCompTimeSync() {
    final data = Uint8List(8);
    // Send time 1 hour ahead
    final now = DateTime.now().add(const Duration(hours: 1));

    // Hour (0-4)
    _setBits(data, 0, 5, now.hour);
    // Minute (5-10)
    _setBits(data, 5, 6, now.minute);
    // Second (11-16)
    _setBits(data, 11, 6, now.second);
    // Millisecond (17-26)
    _setBits(data, 17, 10, now.millisecond);

    _frameCtrl.add(CanFrame(
      id: 0x206,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitComputeCommInfo() {
    final data = Uint8List(8);

    // Dummy time (0-16)
    _setBits(data, 0, 5, 12);
    _setBits(data, 5, 6, 34);
    _setBits(data, 11, 6, 56);

    // UHF Radio State: Healthy (2) bits 17-18
    _setBits(data, 17, 2, 2);

    // Compute State: Unhealthy/Fault (3) bits 21-22
    _setBits(data, 21, 2, 3);

    _frameCtrl.add(CanFrame(
      id: 0x20C,
      idType: CanIdType.standard,
      data: data,
    ));
  }
}
