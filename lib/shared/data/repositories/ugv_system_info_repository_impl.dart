import 'dart:async';

import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:mavlink_module/mavlink_frame.dart';

import '../../../core/comm/comm_manager.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/logger/logger.dart';
import '../../../features/drive/data/mappers/drive_information_mapper.dart';
import '../../../features/drive/domain/entities/drive_information_entity.dart';
import '../../../features/system/data/mappers/health_info_mapper.dart';
import '../../../features/system/domain/entities/health_status_entity.dart';
import '../../domain/entities/mode_entity.dart';
import '../../domain/repositories/ugv_system_info_repository.dart';
import '../mappers/mode_mapper.dart';

class UgvSystemInfoRepositoryImpl implements UgvSystemInfoRepository {
  final CommManager _commManager;
  final Logger _logger;

  StreamSubscription<MavlinkFrame>? _ugvSystemInfoSub;

  /// Stream for UGV mode changes.
  final _modeCtrl = StreamController<ModeEntity>.broadcast();

  /// Stream for UGV telemetry / health changes.
  final _telemetryCtrl = StreamController<HealthStatusEntity>.broadcast();

  /// Stream for Drive Information
  final _driveCtrl = StreamController<DriveInformationEntity>.broadcast();

  UgvSystemInfoRepositoryImpl({
    required CommManager commManager,
    required Logger logger,
  })   : _commManager = commManager,
        _logger = logger;

  @override
  void startUgvSystemInfo() {
    if (_ugvSystemInfoSub != null) return;

    _ugvSystemInfoSub = _commManager
        .watchMessage(
      linkId: AppConstants.primaryLinkId,
      messageId: UgvSystemInfo.kMavlinkMessageId,
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
  Stream<ModeEntity> watchUgvMode() => _modeCtrl.stream;

  @override
  Stream<HealthStatusEntity> watchUgvHealth() => _telemetryCtrl.stream;

  @override
  Stream<DriveInformationEntity> watchDriveInformation() => _driveCtrl.stream;

  void _handleUgvSystemInfo(MavlinkFrame frame) {
    final msg = frame.message as UgvSystemInfo;

    _logger.info("Received", context: {"data": msg.toString()});

    final modeEntity = ModeMapper.toModeEntity(msg);
    final healthStatusEntity = HealthInfoMapper.toHealthStatusEntity(msg);
    final driveInfoEntity = DriveInformationMapper.toDriveInfoEntity(msg);

    _modeCtrl.add(modeEntity);
    _telemetryCtrl.add(healthStatusEntity);
    _driveCtrl.add(driveInfoEntity);

  }
}