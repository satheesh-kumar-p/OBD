import 'dart:async';

import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:mavlink_module/mavlink_frame.dart';

import '../../../core/comm/comm_manager.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/logger/logger.dart';
import '../../domain/entities/ugv_mode_entity.dart';
import '../../domain/entities/ugv_system_entity.dart';
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
  final _telemetryCtrl = StreamController<UgvSystemEntity>.broadcast();

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
  Stream<UgvSystemEntity> watchUgvHealth(String linkId) => _telemetryCtrl.stream;

  void _handleUgvSystemInfo(MavlinkFrame frame) {
    final msg = frame.message as UgvSystemInfo;

    final model = UgvSystemInfoModel(
      ugvSubsystemPresent: msg.ugvSubsystemPresent,
      ugvSubsystemEnabled: msg.ugvSubsystemEnabled,
      ugvSubsystemHealth: msg.ugvSubsystemHealth,
      computeLoad: msg.computeLoad,
      mainVoltage: msg.mainVoltage,
      mainCurrent: msg.mainCurrent,
      vcuFaultErrors: msg.vcuFaultErrors,
      dropRateComm: msg.dropRateComm,
      leftMotorErrors: msg.leftMotorErrors,
      rightMotorErrors: msg.rightMotorErrors,
      sensorBusErrors: msg.sensorBusErrors,
      batteryRemaining: msg.batteryRemaining,
      mainMode: msg.mainMode,
      subMode: msg.subMode,
      intendedMainMode: msg.intendedMainMode,
      intendedSubMode: msg.intendedSubMode,
      modeChangeReason: msg.modeChangeReason,
    );

    final modeEntity = model.toModeEntity();
    final telemetryEntity = model.toSystemEntity();

    _modeCtrl.add(modeEntity);
    _telemetryCtrl.add(telemetryEntity);

    _logger.debug(
      'UGV_SYSTEM_INFO rx',
      context: {
        'mainMode': modeEntity.mainMode.name,
        'subMode': modeEntity.subMode.name,
        'batteryRemaining': telemetryEntity.batteryRemaining,
        'mainCurrent': telemetryEntity.mainCurrent,
      },
    );
  }
}