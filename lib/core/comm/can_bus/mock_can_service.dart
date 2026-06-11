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

    // Start emitting fake robot data
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
      _emitMcTempVolt();
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

      data[byteIdx] &= ~(1 << bitIdx);
      if (((value >> i) & 0x01) == 1) {
        data[byteIdx] |= (1 << bitIdx);
      }
    }
  }

  void _emitSystemInfo() {
    final data = Uint8List(8);
    
    // Status values: 2=Healthy, 3=Unhealthy, 1=No Comm
    _setBits(data, 38, 2, 2); // rear MC
    _setBits(data, 36, 2, 2); // front MC
    _setBits(data, 34, 2, 2); // hv battery
    _setBits(data, 32, 2, 2); // lv battery
    _setBits(data, 30, 2, 2); // lv pdu
    _setBits(data, 28, 2, 2); // dcDc48v12v
    _setBits(data, 26, 2, 2); // dcDc12v5v
    _setBits(data, 24, 2, 2); // vcu
    _setBits(data, 22, 2, 2); // frontLeftMotor
    _setBits(data, 20, 2, 2); // rearLeftMotor
    _setBits(data, 18, 2, 2); // frontRightMotor
    _setBits(data, 16, 2, 2); // rearRightMotor
    _setBits(data, 14, 2, 2); // compute

    _frameCtrl.add(CanFrame(
      id: 0x203,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitDriveInfo() {
    final data = Uint8List(8);

    // Motor Faults (8 bits each, 0 = Healthy)
    _setBits(data, 39, 8, 0); // RL
    _setBits(data, 31, 8, 0); // RR
    _setBits(data, 23, 8, 0); // FL
    _setBits(data, 15, 8, 0); // FR

    // MC Faults (6 bits each)
    _setBits(data, 9, 6, 0); // Rear MC
    _setBits(data, 3, 6, 0); // Front MC

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

    // SOC: 85% (bits 17-24)
    _setBits(data, 17, 8, 85);
    // LV SOC: 92% (bits 25-32)
    _setBits(data, 25, 8, 24);

    _frameCtrl.add(CanFrame(
      id: 0x200,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitModeInfo() {
    final data = Uint8List(8);

    _setBits(data, 36, 4, 1); // MainMode: 1
    _setBits(data, 32, 4, 0); // SubMode: 0
    _setBits(data, 28, 4, 2); // SpeedMode: 2
    _setBits(data, 24, 4, 1); // DriveMode: 1
    _setBits(data, 23, 1, 1); // Armed: true
    _setBits(data, 22, 1, 1); // Headlights: true
    _setBits(data, 21, 1, 0); // FogLights: false
    _setBits(data, 20, 1, 0); // BrakeLights: false

    _frameCtrl.add(CanFrame(
      id: 0x20B,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitGlobalTimeInfo() {
    final data = Uint8List(8);
    final now = DateTime.now();

    _setBits(data, 56, 8, now.year - 2000);
    _setBits(data, 48, 8, now.month);
    _setBits(data, 40, 8, now.day);
    _setBits(data, 32, 8, now.hour);
    _setBits(data, 24, 8, now.minute);
    _setBits(data, 16, 8, now.second);

    _frameCtrl.add(CanFrame(
      id: 0x202,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitCompTimeSync() {
    final data = Uint8List(8);
    final now = DateTime.now();

    _setBits(data, 56, 8, now.hour);
    _setBits(data, 48, 8, now.minute);
    _setBits(data, 40, 8, now.second);
    _setBits(data, 30, 10, now.millisecond);

    _frameCtrl.add(CanFrame(
      id: 0x206,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitComputeCommInfo() {
    final data = Uint8List(8);

    // UHF Radio State: Healthy (2) bits 38-39
    _setBits(data, 38, 2, 2);
    // L-Band Radio State: Healthy (2) bits 36-37
    _setBits(data, 36, 2, 2);

    _frameCtrl.add(CanFrame(
      id: 0x20C,
      idType: CanIdType.standard,
      data: data,
    ));
  }

  void _emitMcTempVolt() {
    final data = Uint8List(8);

    // 37-46: Rear MC Voltage (Scale: 0.1V) -> 48.0V
    _setBits(data, 37, 10, 480);
    // 27-36: Front MC Voltage (Scale: 0.1V) -> 47.5V
    _setBits(data, 27, 10, 475);
    // 16-23: Rear MC Temp -> 35 C
    _setBits(data, 16, 8, 35);
    // 8-15: Front MC Temp -> 32 C
    _setBits(data, 8, 8, 32);

    _frameCtrl.add(CanFrame(
      id: 0x211,
      idType: CanIdType.standard,
      data: data,
    ));
  }
}
