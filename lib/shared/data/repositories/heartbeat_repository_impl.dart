import 'dart:async';
import 'package:mavlink_nrt/dialects/ardupilotmega.dart';
import 'package:mavlink_nrt/mavlink.dart';
import 'package:scout_obd/core/comm/comm_manager.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/data/models/heartbeat_model.dart';
import 'package:scout_obd/shared/domain/entities/heartbeat_entity.dart';
import 'package:scout_obd/shared/domain/repositories/heartbeat_repository.dart';

const int _kMsgIdHeartbeat = 0;
const int _kHeartbeatStaleTimeSec = 3;

class HeartbeatRepositoryImpl implements HeartbeatRepository {

  static const int _kTypeOsd = 39;
  static const int _kAutopilotInvalid = 8;
  static const int _kStateActive = 4;
  static const int _kMavlinkVersion = 3;

  final CommManager _commManager;
  final Logger _logger;

  Timer? _sendTimer;
  Timer? _watchdogTimer;
  StreamSubscription<MavlinkFrame>? _heartbeatSub;

  final _connectionCtrl = StreamController<bool>.broadcast();
  final _heartbeatCtrl = StreamController<HeartbeatEntity>.broadcast();

  DateTime? _lastReceivedAt;
  bool _isConnected = false;

  HeartbeatRepositoryImpl({required CommManager commManager, required Logger logger})
      : _commManager = commManager,
        _logger = logger;

  @override
  Stream<HeartbeatEntity> watchHeartbeat(String linkId) => _heartbeatCtrl.stream;

  @override
  Stream<bool> isActive(String linkId) => _connectionCtrl.stream;

  @override
  void startHeartbeat(String linkId) {
    if (_sendTimer != null) return;

    _connectionCtrl.add(false);
    _isConnected = false;

    // 1. Subscribe to incoming heartbeats
    _heartbeatSub = _commManager
        .watchMessage(linkId: linkId, messageId: _kMsgIdHeartbeat)
        .where((f) => f.systemId == AppConstants.ugvSystemId)
        .listen(_handleHeartbeat);

    // 2. Start sender loop
    _sendTimer = Timer.periodic(const Duration(seconds: 1), (_) => _sendHeartbeat(linkId));

    // 3. Start watchdog loop
    _watchdogTimer = Timer.periodic(const Duration(milliseconds: 500), (_) => _checkLiveness());

    _logger.info('Heartbeat service started');
  }

  @override
  void stopHeartbeat() {
    _sendTimer?.cancel();
    _watchdogTimer?.cancel();
    _heartbeatSub?.cancel();

    _sendTimer = null;
    _watchdogTimer = null;
    _heartbeatSub = null;
    _lastReceivedAt = null;

    _logger.info('Heartbeat service stopped');
  }

  void _sendHeartbeat(String linkId) {
    _commManager.send(
      linkId: linkId,
      message: Heartbeat(
        type: _kTypeOsd,
        autopilot: _kAutopilotInvalid,
        baseMode: 0,
        customMode: 0,
        systemStatus: _kStateActive,
        mavlinkVersion: _kMavlinkVersion,
      ),
    ).catchError((Object err) => _logger.error("Heartbeat send failed", error: err));
  }

  void _handleHeartbeat(MavlinkFrame frame) {
    final msg = frame.message as Heartbeat;

    final entity = HeartbeatModel(
      type: msg.type,
      autopilot: msg.autopilot,
      baseMode: msg.baseMode,
      customMode: msg.customMode,
      systemStatus: msg.systemStatus,
      mavlinkVersion: msg.mavlinkVersion,
    ).toEntity(AppConstants.primaryLinkId, frame.systemId);

    _lastReceivedAt = DateTime.now();

    _heartbeatCtrl.add(entity);
    _updateConnectionStatus(true);
  }

  void _checkLiveness() {
    if (_lastReceivedAt == null) return;

    final isStale = DateTime.now().difference(_lastReceivedAt!).inSeconds > _kHeartbeatStaleTimeSec;
    if (isStale && _isConnected) {
      _updateConnectionStatus(false);
    }
  }

  void _updateConnectionStatus(bool connected) {
    if (_isConnected == connected) return;
    _isConnected = connected;
    _connectionCtrl.add(connected);
    _logger.info('Heartbeat connectivity changed: ${connected ? "CONNECTED" : "DISCONNECTED"}');
  }
}