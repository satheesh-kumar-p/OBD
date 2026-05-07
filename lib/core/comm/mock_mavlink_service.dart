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

    final now = DateTime.now();

    final msg = UgvSystemInfo(
      ugvSubsystemPresent: 0x03ff, // all 10 subs present
      ugvSubsystemEnabled: 0x03ff, // all enabled
      ugvSubsystemHealth: 0x03ff,  // all healthy
      computeLoad: 500,            // 50.0%
      mainVoltage: 24000,          // 24 V
      mainCurrent: 1200,           // 12 A
      vcuFaultErrors: 0,
      dropRateComm: 0,
      leftMotorErrors: 0,
      rightMotorErrors: 0,
      sensorBusErrors: 0,
      batteryRemaining: 85,
      mainMode: 1,                 // MODE_B
      subMode: 10,                 // HOLD
      intendedMainMode: 1,
      intendedSubMode: 10,
      modeChangeReason: 0,         // GCS_COMMAND
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
