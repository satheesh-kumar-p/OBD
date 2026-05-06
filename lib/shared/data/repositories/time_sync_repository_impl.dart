import 'dart:async';

import 'package:mavlink_nrt/dialects/ardupilotmega.dart';
import 'package:mavlink_nrt/mavlink.dart';
import 'package:scout_obd/core/comm/comm_manager.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/data/models/system_time_model.dart';
import 'package:scout_obd/shared/data/models/time_sync_model.dart';
import 'package:scout_obd/shared/data/models/time_sync_request_model.dart';
import 'package:scout_obd/shared/domain/entities/system_time_entity.dart';
import 'package:scout_obd/shared/domain/entities/time_sync_entity.dart';
import 'package:scout_obd/shared/domain/repositories/time_sync_repository.dart';

const int _kMsgIdSystemTime = 2;
const int _kMsgIdTimesync = 111;

class TimeSyncRepositoryImpl implements TimeSyncRepository {
  final CommManager _commManager;
  final Logger _logger;

  Timer? _syncTimer;
  int? _lastSentTs1;

  StreamSubscription<MavlinkFrame>? _timeSyncMsgSub;

  final _timeSyncCtrl = StreamController<TimeSyncEntity>.broadcast();

  TimeSyncRepositoryImpl({
    required CommManager commManager,
    required Logger logger,
  }) : _commManager = commManager,
       _logger = logger;

  @override
  void startTimeSync() {
    if (_syncTimer != null) return;

    _timeSyncMsgSub = _commManager
        .watchMessage(
          linkId: AppConstants.primaryLinkId,
          messageId: _kMsgIdTimesync,
        )
        .where((f) => f.systemId == AppConstants.obdSystemId)
        .listen(_handleTimeSync);

    _sendRequest();
    _syncTimer = Timer.periodic(
      AppConstants.timeSyncInterval,
      (_) => _sendRequest(),
    );

    _logger.info('Timesync started');
  }

  @override
  void stopTimeSync() async {
    _syncTimer?.cancel();
    _syncTimer = null;
    await _timeSyncMsgSub?.cancel();
    _timeSyncMsgSub = null;
    _lastSentTs1 = null;

    _logger.info('Timesync stopped');
  }

  @override
  Stream<SystemTimeEntity> watchSystemTime() {
    return _commManager
        .watchMessage(
          linkId: AppConstants.primaryLinkId,
          messageId: _kMsgIdSystemTime,
        )
        .where((f) => f.systemId == AppConstants.obdSystemId)
        .map((frame) {
          final msg = frame.message as SystemTime;

          final entity = SystemTimeModel(
            timeUnixUsec: msg.timeUnixUsec,
            timeBootMs: msg.timeBootMs,
          ).toEntity(AppConstants.primaryLinkId);

          _logger.debug('SYSTEM_TIME rx', context: {'upTimeMs': entity.upTimeMs});

          return entity;
        });
  }

  @override
  Stream<TimeSyncEntity> watchTimeSync() => _timeSyncCtrl.stream;

  void _sendRequest() {
    final nowUs = DateTime.now().microsecondsSinceEpoch;

    final payload = TimeSyncRequestModel(ts1: nowUs);
    _lastSentTs1 = payload.ts1;

    _commManager
        .send(
          linkId: AppConstants.primaryLinkId,
          message: Timesync(
            tc1: payload.tc1,
            // Responding component timestamp (UGV-Main Compute)
            ts1: payload.ts1,
            // Syncing component timestamp (Clients: OBD, GCS, Hand controller)
            targetSystem: AppConstants.ugvSystemId,
            targetComponent: AppConstants.ugvComponentId,
          ),
        )
        .catchError(
          (Object err) => _logger.error("Timesync send failed", error: err),
        );

    _logger.debug(
      "Timesync sent",
      context: {
        'ts1Us': payload.ts1,
        'targetSystemId': AppConstants.ugvSystemId,
        'targetComponentId': AppConstants.ugvComponentId,
      },
    );
  }

  void _handleTimeSync(MavlinkFrame frame) {
    final msg = frame.message as Timesync;

    if (msg.tc1 == 0) return; // Don't handle timesync requests

    if (msg.ts1 != _lastSentTs1 || _lastSentTs1 == null) {
      _logger.warn(
        "Timesync response mismatched/stale",
        context: {'expected': _lastSentTs1, 'received': msg.ts1},
      );
      return;
    }

    final model = TimeSyncModel(
      tc1: msg.tc1,
      ts1: msg.ts1,
      targetSystem: msg.targetSystem,
      targetComponent: msg.targetComponent,
    );

    final entity = model.toEntity(AppConstants.primaryLinkId);
    _timeSyncCtrl.add(entity);
    _lastSentTs1 = null;

    _logger.info(
      'Timesync succeeded',
      context: {
        'offsetMs': (entity.timeOffsetUs / 1e3).toStringAsFixed(3),
        'rttMs': (entity.roundTripUs / 1e3).toStringAsFixed(3),
      },
    );
  }
}
