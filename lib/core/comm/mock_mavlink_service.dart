import 'dart:async';
import 'dart:typed_data';

import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:mavlink_module/mavlink.dart';
import 'package:scout_obd/core/comm/mavlink_service.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/logger/logger.dart';

/// Mock MAVLink backend that emits fake frames for testing.
/// Active when `AppConstants.useMockBackends == true`.
///
/// Emits:
///   • HEARTBEAT       every 1 second   (msg 0)
///   • SYSTEM_TIME     every 5 seconds  (msg 2)
///   • TIMESYNC echo   ~20 ms after GCS TIMESYNC request (msg 111)
class MockMavlinkService implements MavlinkService {
  MockMavlinkService(this._logger);

  final Logger _logger;

  final _frameCtrl = StreamController<MavlinkFrame>.broadcast();
  final _connectionCtrl = StreamController<bool>();

  Timer? _heartbeatTimer;
  Timer? _systemTimeTimer;
  Timer? _ugvSystemInfoTimer;
  bool _connected = false;
  int _bootMs = 0;
  int _sequence = 0;

  // ── MavlinkService interface ──────────────────────────────────────────────

  @override
  Stream<MavlinkFrame> get frameStream => _frameCtrl.stream;

  @override
  Stream<bool> get connectionStream => _connectionCtrl.stream;

  @override
  bool get isConnected => _connected;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  Future<void> connect() async {
    if (_connected) return;

    _connected = true;
    _connectionCtrl.add(true);
    _logger.info('MockMavlinkService connected');

    // _heartbeatTimer = Timer.periodic(AppConstants.heartbeatSendInterval, (_) {
    //   _bootMs += AppConstants.heartbeatSendInterval.inMilliseconds;
    //   _emitHeartbeat();
    // });
    //
    // _systemTimeTimer = Timer.periodic(
    //   const Duration(seconds: 5),
    //   (_) => _emitSystemTime(),
    // );
    //
    // _ugvSystemInfoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    //   _emitUgvSystemInfo();
    // });

    // Emit one of each immediately so downstream repos are not “stuck”.
    // _emitHeartbeat();
    // _emitSystemTime();
    // _emitUgvSystemInfo();
  }

  @override
  Future<void> disconnect() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _systemTimeTimer?.cancel();
    _systemTimeTimer = null;

    _connected = false;
    _connectionCtrl.add(false);
    _logger.info('MockMavlinkService disconnected');

    if (!_frameCtrl.isClosed) {
      _frameCtrl.close();
    }
  }

  @override
  Future<void> send(MavlinkMessage message) async {
    // ── Send: intercept and echo TIMESYNC ─────────────────────────────────────
    if (message.mavlinkMessageId == 111) {
      final req = message as Timesync;

      // Only handle TIMESYNC requests (tc1 == 0)
      if (req.tc1 != 0) return;

      // Simulate ~20 ms one‑way delay, then emit UGV echo.
      await Future<void>.delayed(const Duration(milliseconds: 20), () {
        if (!_connected) return;

        final ugvNowUs = DateTime.now()
            .add(const Duration(hours: 1))
            .microsecondsSinceEpoch;
        _emitRaw(
          Timesync(
            tc1: ugvNowUs,
            ts1: req.ts1,
            targetSystem: AppConstants.ugvSystemId,
            targetComponent: AppConstants.ugvComponentId,
          ),
        );
      });
    }

    // Handle software version and checksum (UGV_Component_Version Message)
    if (message.mavlinkMessageId == 50002) {

      final payload = message.serialize();  // Get ByteData

      // Use THEIR parsing methods exactly!
      final softwareVersion = payload.getUint32(0, Endian.little);
      final checksum = MavlinkMessage.asUint8List(payload, 4, 32);  // 32 bytes
      final targetSystem = payload.getUint8(36);
      final targetComponent = payload.getUint8(37);

      // Unpack 1.2.3
      final major = (softwareVersion >> 24) & 0xFF;
      final minor = (softwareVersion >> 16) & 0xFF;
      final patch = (softwareVersion >> 8) & 0xFF;

      final checksumHex = checksum
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();

      _logger.info('Software Version Received', context: {
        'version': '$major.$minor.$patch',
        'checksum': checksumHex,
        'targetSys': targetSystem,
        'targetComp': targetComponent,
      });
    }

    if (message is CommandLong &&
        message.command == 512 &&
        message.param1 == 50003.0
    ) {
      final cmd = message;
      final param2 = cmd.param2.toInt(); // 2 = software, 3 = hardware

      // If your app sends both at once, you can respond with both types quickly
      Future<void> sendMockResponse(int type) {
        // Pretend this is FIRMWARE_VERSION_TYPE_BETA (128) in TYPE byte
        final rawType = type == 2
            ? 0x00000000 // dev / official if you want, or 128 for beta
            : 0x00000080;

        final swValue = 0x01020000 | rawType; // 1.2.0 + type

        final checksum = Uint8List.fromList([
          for (var i = 0; i < 32; i++) i % 256,
        ]);

        final ugvSwVer = UgvSubsystemVersion(
          type: type,
          component1Sw: swValue,
          component2Sw: swValue + 1,
          component3Sw: swValue + 2,
          component4Sw: swValue + 3,
          component5Sw: swValue + 4,
          component1Checksum: checksum,
          component2Checksum: checksum,
          component3Checksum: checksum,
          component4Checksum: checksum,
          component5Checksum: checksum,
        );

        return Future<void>.delayed(const Duration(milliseconds: 20), () {
          if (!_connected) return;
          _emitRaw(ugvSwVer);
        });
      }

      if (param2 == 2.0) {
        // Mock software versions response
        _logger.info("Sending mock software component versions");
        sendMockResponse(2);
      } else if (param2 == 3.0) {
        // Mock hardware versions response
        _logger.info("Sending mock hardware component versions");
        sendMockResponse(3);
      }

      return; // skip default send echo behavior
    }

  }

  // ── Frame emitters ────────────────────────────────────────────────────────

  void _emitHeartbeat() => _emitRaw(
    Heartbeat(
      type: 10,
      // MAV_TYPE_GROUND_ROVER
      autopilot: 3,
      // MAV_AUTOPILOT_ARDUPILOTMEGA
      baseMode: 64,
      // MAV_MODE_FLAG_MANUAL_INPUT_ENABLED
      customMode: 0,
      systemStatus: 3,
      // MAV_STATE_STANDBY → SafeHold
      mavlinkVersion: 3,
    ),
  );

  void _emitSystemTime() => _emitRaw(
    SystemTime(
      timeUnixUsec: DateTime.now().toUtc().microsecondsSinceEpoch,
      timeBootMs: _bootMs,
    ),
  );

  void _emitUgvSystemInfo() {
    if (_frameCtrl.isClosed) return;

    // ── VCU FAULT ERRORS (bitmask) ──────────────────────────────────────────
    // Example: bit 0 = general fault, bit 2 = mode logic fault
    final vcuFaultErrors = 0x05; // 0b0000_0101

    // ── COMM DROP RATE (cA) → percentage format: dropRateComm / 100.0 ─────
    final dropRateComm = 2324; // 23.24% in ICD scale (23.24 * 100)

    // ── MOTOR ERRORS (bitmask) ─────────────────────────────────────────────
    // LEFT: overload + overTemp + phaseLoss
    final leftMotorErrors = 0x0D; // 0b0000_1101 → overload(1) | overTemp(2) | phaseLoss(16? verify bit)
    // If your bits are different, adjust; example:
    // leftMotorErrors = UgvMotorError.overload.bit |
    //                   UgvMotorError.overTemp.bit |
    //                   UgvMotorError.phaseLoss.bit;

    // RIGHT: stalled + encoderFault
    final rightMotorErrors = 0x48; // 0b0100_1000 → stalled(8) | encoderFault(64)

    // ── SENSOR BUS (BMS) ERRORS ────────────────────────────────────────────
    final sensorBusErrors = 0x0B; // 0b0000_1011
    // 0x01 = underVoltage, 0x02 = overCurrent, 0x08 = overTemp
    // -> "UNDER_VOLTAGE, OVER_CURRENT, OVER_TEMP"

    // ── Realistic mix of present / enabled / healthy ────────────────────────
    // 10 subsystems in total; bits 0–9

    // 1. All present EXCEPT leftMotor (bit 2, 0x0004)
    final ugvSubsystemPresent = 0x03FF & ~0x0004; // 0b0011_1111_1011

    // 2. All enabled EXCEPT bms (bit 4, 0x0010) and handCtrl (bit 8, 0x0100)
    final ugvSubsystemEnabled = 0x03FF & ~(0x0010 | 0x0100); // 0b0011_1001_1111

    // 3. All healthy EXCEPT pdu (bit 5, 0x0020) and uhfRadio (bit 6, 0x0040)
    final ugvSubsystemHealth = 0x03FF & ~(0x0020 | 0x0040); // 0b0011_1001_1111

    final mainMode = 1;   // MODE_B
    final subMode = 10;   // HOLD

    final msg = UgvSystemInfo(
      ugvSubsystemPresent: ugvSubsystemPresent,
      ugvSubsystemEnabled: ugvSubsystemEnabled,
      ugvSubsystemHealth: ugvSubsystemHealth,
      computeLoad: 500,           // 50.0%
      mainVoltage: 24000,         // 24 V
      mainCurrent: 1200,          // 12 A
      vcuFaultErrors: vcuFaultErrors,
      dropRateComm: dropRateComm,
      leftMotorErrors: leftMotorErrors,
      rightMotorErrors: rightMotorErrors,
      sensorBusErrors: sensorBusErrors,
      batteryRemaining: 85,
      mainMode: mainMode,
      subMode: subMode,
      intendedMainMode: mainMode,
      intendedSubMode: subMode,
      modeChangeReason: 0,        // GCS_COMMAND
    );

    _emitRaw(msg);
  }

  void _emitRaw(MavlinkMessage message) {
    if (_frameCtrl.isClosed) return;

    _frameCtrl.add(
      MavlinkFrame.v2(
        _sequence++ & 0xFF,
        AppConstants.ugvSystemId,
        AppConstants.ugvComponentId,
        message,
      ),
    );
  }
}
