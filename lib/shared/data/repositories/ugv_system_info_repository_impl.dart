import 'dart:async';

import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:mavlink_module/mavlink_frame.dart';

import '../../../core/comm/comm_manager.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/logger/logger.dart';
import '../../../features/drive/data/mappers/drive_information_mapper.dart';
import '../../../features/drive/domain/entities/drive_information_entity.dart';
import '../../../features/system/data/mappers/system_info_mapper.dart';
import '../../../features/system/domain/entities/system_info_entity.dart';
import '../../domain/entities/mode_entity.dart';
import '../../domain/repositories/ugv_system_info_repository.dart';
import '../mappers/mode_mapper.dart';

class UgvSystemInfoRepositoryImpl implements UgvSystemInfoRepository {
  final CommManager _commManager;
  final Logger _logger;

  StreamSubscription<MavlinkFrame>? _ugvSystemInfoSub;

  final _mavlinkMessageCtrl = StreamController<MavlinkFrame>.broadcast();

  /// Stream for UGV mode changes.
  final _modeCtrl = StreamController<ModeEntity>.broadcast();

  /// Stream for UGV telemetry / health changes.
  final _healthCtrl = StreamController<SystemInfoEntity>.broadcast();

  /// Stream for Drive Information
  final _driveCtrl = StreamController<DriveInformationEntity>.broadcast();

  UgvSystemInfoRepositoryImpl({
    required CommManager commManager,
    required Logger logger,
  }) : _commManager = commManager,
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
        .listen(
          (msg) => _mavlinkMessageCtrl.add(msg),
          onError: (e) => _logger.error("Mavlink Stream Error $e"),
        );
  }

  @override
  void stopUgvSystemInfo() async {
    await _ugvSystemInfoSub?.cancel();
    _ugvSystemInfoSub = null;

    await _modeCtrl.close();
    await _healthCtrl.close();
    await _driveCtrl.close();
  }

  @override
  Stream<ModeEntity> watchUgvMode() {
    return _mavlinkMessageCtrl.stream
        .map((msg) {
          final data = ModeMapper.toModeEntity(msg.message as UgvSystemInfo);
          _logger.debug("Main Mode ${data.mainMode}, Sub Mode: ${data.subMode}");
          return data;
        })
        .handleError(
          (e, st) => _logger.error(
            "Mode information mapping failed",
            context: {"error": e.toString()},
            stack: st,
          ),
        );
  }

  @override
  Stream<SystemInfoEntity> watchUgvHealth() {
    return _mavlinkMessageCtrl.stream
        .map(
          (msg) => SystemInfoMapper.toHealthStatusEntity(
            msg.message as UgvSystemInfo,
          ),
        )
        .handleError(
          (e, st) => _logger.error(
            "Health information mapping failed",
            context: {"error": e.toString()},
            stack: st,
          ),
        );
  }

  @override
  Stream<DriveInformationEntity> watchDriveInformation() {
    return _mavlinkMessageCtrl.stream
        .map(
          (msg) => DriveInformationMapper.toDriveInfoEntity(
            msg.message as UgvSystemInfo,
          ),
        )
        .handleError(
          (e, st) => _logger.error(
            "Drive information mapping failed",
            context: {"error": e.toString()},
            stack: st,
          ),
        );
  }
}
