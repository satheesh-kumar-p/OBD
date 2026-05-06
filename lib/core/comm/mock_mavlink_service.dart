
import 'dart:async';

import 'package:mavlink_nrt/dialects/ardupilotmega.dart';
import 'package:mavlink_nrt/mavlink.dart';
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
  final _connectionCtrl = StreamController<bool>.broadcast();

  Timer? _heartbeatTimer;
  Timer? _systemTimeTimer;
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

    // Emit one of each immediately so downstream repos are not “stuck”.
    _emitHeartbeat();
    _emitSystemTime();
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

  // ── Send: intercept and echo TIMESYNC ─────────────────────────────────────

  @override
  Future<void> send(MavlinkMessage message) async {
    if (message.mavlinkMessageId != 111) return;

    final req = message as Timesync;

    // Only handle TIMESYNC requests (tc1 == 0)
    if (req.tc1 != 0) return;

    // Simulate ~20 ms one‑way delay, then emit UGV echo.
    await Future<void>.delayed(const Duration(milliseconds: 20), () {
      if (!_connected) return;

      final ugvNowUs = DateTime.now().microsecondsSinceEpoch;
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

  // ── Frame emitters ────────────────────────────────────────────────────────

  void _emitHeartbeat() => _emitRaw(
    Heartbeat(
      type: 10, // MAV_TYPE_GROUND_ROVER
      autopilot: 3, // MAV_AUTOPILOT_ARDUPILOTMEGA
      baseMode: 64, // MAV_MODE_FLAG_MANUAL_INPUT_ENABLED
      customMode: 0,
      systemStatus: 3, // MAV_STATE_STANDBY → SafeHold
      mavlinkVersion: 3,
    ),
  );

  void _emitSystemTime() => _emitRaw(
    SystemTime(
      timeUnixUsec: DateTime.now().toUtc().microsecondsSinceEpoch,
      timeBootMs: _bootMs,
    ),
  );

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