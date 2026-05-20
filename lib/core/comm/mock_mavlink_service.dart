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

    _heartbeatTimer = Timer.periodic(AppConstants.heartbeatSendInterval, (_) {
      _bootMs += AppConstants.heartbeatSendInterval.inMilliseconds;
      _emitHeartbeat();
    });

    _systemTimeTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _emitSystemTime(),
    );

    _ugvSystemInfoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _emitUgvSystemInfo();
    });

    // Emit one of each immediately so downstream repos are not “stuck”.
    _emitHeartbeat();
    _emitSystemTime();
    _emitUgvSystemInfo();
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

    // subsystemHealth1: bits 0-7 → subsystems 0-3
    // [LeftMotorCtrl(0-1), RightMotorCtrl(2-3), HV_Batt(4-5), LV_Batt(6-7)]
    final health1 = (1 << 0) | (2 << 2) | (2 << 4) | (3 << 6);  // healthy, healthy, healthy, unhealthy

    // subsystemHealth2: bits 0-7 → subsystems 4-7
    // [LV_PDU(0-1), DCDC_48V(2-3), DCDC_5V(4-5), VCU(6-7)]
    final health2 = (2 << 0) | (1 << 2) | (2 << 4) | (2 << 6);  // healthy, noComm, healthy, healthy

    // subsystemHealth3: bits 0-7 → subsystems 8-11
    // [FrontLeftMotor(0-1), RearLeftMotor(2-3), FrontRightMotor(4-5), RearRightMotor(6-7)]
    final health3 = (3 << 0) | (2 << 2) | (1 << 4) | (2 << 6);  // unhealthy, healthy, noComm, healthy

    // subsystemHealth4: bits 0-3 → subsystems 12-14 (UHF=12 healthy!)
    // [UHF_Radio(0-1), L_Band(2-3), Compute(4-5)]
    final health4 = (2 << 0) | (3 << 2) | (1 << 4);  // UHF=healthy, L_Band=unhealthy, Compute=noComm


    final mainMode = 2;   // MODE_B
    final subMode = 10;   // HOLD

    final msg = UgvSystemInfo(
      subsystemHealth1: health1,
      subsystemHealth2: health2,
      subsystemHealth3: health3,
      subsystemHealth4: health4,
      batterySoc: 85,
      mainMode: mainMode,
      subMode: subMode,
      intendedMainMode: mainMode,
      intendedSubMode: subMode,
      modeChangeReason: 0,
      // TODO: Change these values after integrating ICD
      rearLeftMotorFaults: 20,
      rearRightMotorFaults: 20,
      frontLeftMotorFaults: 20,
      frontRightMotorFaults: 20,
      leftMcFaults: 20,
      rightMcFaults: 20,
      leftMcVoltage: 350,
      rightMcVoltage: 400,
      leftMcTemperature: 39,
      rightMcTemperature: 45,
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
