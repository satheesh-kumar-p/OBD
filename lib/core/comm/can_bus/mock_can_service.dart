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

    // Start emitting fake robot data (e.g. System Info 0x203)
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_connected) return;
      _emitSystemInfo();
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

  void _emitSystemInfo() {
    // Construct fake payload for 0x203 (Subsystem State)
    // Based on SystemInfoMapper bit layout
    final data = Uint8List(8);

    // bits 28-31: Motor Controllers (2 bits each)
    // Value 1 = No Communication. Binary 01.
    // Bits 28-29 = 01, Bits 30-31 = 01 -> 0x50 in Byte 3
    data[3] = 0x50;

    // Byte 4 (bits 32-39): 
    // hvBattery(32-33)=2(Healthy/10), lvBattery(34-35)=3(Unhealthy/11), 
    // lvPdu(36-37)=2(Healthy/10), dc48(38-39)=2(Healthy/10)
    // Binary: 10 10 11 10 -> 0xAE
    data[4] = 0xAE;

    // Byte 5 (bits 40-47): 
    // dc12(40-41)=3(Unhealthy/11), vcu(42-43)=3(Unhealthy/11), 
    // frontLeftMotor(44-45)=2(Healthy/10), rearLeftMotor(46-47)=2(Healthy/10)
    // Binary: 10 10 11 11 -> 0xAF
    data[5] = 0xAF;

    // Byte 6 (bits 48-55): 
    // frontRightMotor(48-49)=2(Healthy/10), rearRightMotor(50-51)=2(Healthy/10)
    // Binary: 0000 10 10 -> 0x0A
    data[6] = 0x0A;

    _frameCtrl.add(CanFrame(
      id: 0x203,
      idType: CanIdType.standard,
      data: data,
    ));
  }
}
