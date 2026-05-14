import 'dart:async';

import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:mavlink_module/mavlink_frame.dart';
import 'package:scout_obd/features/system/domain/entities/health_status_entity.dart';

import '../../../core/comm/comm_manager.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/logger/logger.dart';
import '../../domain/entities/ugv_mode_entity.dart';
import '../../domain/repositories/ugv_system_info_repository.dart';
import '../models/ugv_system_info_model.dart';

const int _kMsgIdUgvSystemInfo = 50001;

class UgvSystemInfoRepositoryImpl implements UgvSystemInfoRepository {
  final CommManager _commManager;
  final Logger _logger;

  StreamSubscription<MavlinkFrame>? _ugvSystemInfoSub;

  /// Stream for UGV mode changes.
  final _modeCtrl = StreamController<UgvModeEntity>.broadcast();

  /// Stream for UGV telemetry / health changes.
  final _telemetryCtrl = StreamController<HealthStatusEntity>.broadcast();

  UgvSystemInfoRepositoryImpl({
    required CommManager commManager,
    required Logger logger,
  })   : _commManager = commManager,
        _logger = logger;

  @override
  void startUgvSystemInfo(String linkId) {
    if (_ugvSystemInfoSub != null) return;

    _ugvSystemInfoSub = _commManager
        .watchMessage(
      linkId: linkId,
      messageId: _kMsgIdUgvSystemInfo,
    )
        .where((frame) => frame.systemId == AppConstants.ugvSystemId)
        .listen(_handleUgvSystemInfo);
  }

  @override
  void stopUgvSystemInfo() async {
    await _ugvSystemInfoSub?.cancel();
    _ugvSystemInfoSub = null;

    await _modeCtrl.close();
    await _telemetryCtrl.close();
  }

  @override
  Stream<UgvModeEntity> watchUgvMode(String linkId) => _modeCtrl.stream;

  @override
  Stream<HealthStatusEntity> watchUgvHealth(String linkId) => _telemetryCtrl.stream;

  void _handleUgvSystemInfo(MavlinkFrame frame) {
    final msg = frame.message as UgvSystemInfo;

    final model = UgvSystemInfoModel(
      subsystemHealth1: msg.subsystemHealth1,
      subsystemHealth2: msg.subsystemHealth2,
      subsystemHealth3: msg.subsystemHealth3,
      subsystemHealth4: msg.subsystemHealth4,
      batterySoc: msg.batterySoc,
      mainMode: msg.mainMode,
      subMode: msg.subMode,
      intendedMainMode: msg.intendedMainMode,
      intendedSubMode: msg.intendedSubMode,
      modeChangeReason: msg.modeChangeReason,
    );

    final modeEntity = model.toModeEntity();
    final healthStatusEntity = model.toHealthStatusEntity();

    _modeCtrl.add(modeEntity);
    _telemetryCtrl.add(healthStatusEntity);

    _logger.debug('Map entries ${healthStatusEntity.subsystemHealthMap.keys}');
    _logger.debug(
      'UGV_SYSTEM_INFO rx',
      context: {
        'mainMode': modeEntity.mainMode.name,
        'subMode': modeEntity.subMode.name,
        'uhfRadio': healthStatusEntity.subsystemHealthMap['UHF Radio']?.value
      },
    );
  }
}