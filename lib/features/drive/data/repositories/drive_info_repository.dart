import 'dart:async';

import '../mappers/drive_info_mapper.dart';
import '../../domain/entities/drive_information_entity.dart';
import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../shared/domain/repositories/can_data_repository.dart';

class DriveInfoRepository implements CanDataRepository<DriveInformationEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _driveCtrl = StreamController<DriveInformationEntity>.broadcast();

  final _mapper = DriveInfoParser();

  StreamSubscription? _driveSub;

  DriveInfoRepository({
    required CanCommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_driveSub != null) return;

    _driveSub = _canManager
        .watchMessage(_mapper.messageId)
        .listen(
          (frame) {
        final driveInfo = _mapper.parse(frame.data);

        _driveCtrl.add(driveInfo);

        _logger.debug(
          'Drive Info - Front Left Motor OverSpeed: ${driveInfo.frontLeftMotor.overSpeed}',
        );
      },
      onError: (e) {
        _logger.error('CAN Drive Info Stream Error $e');
      },
    );
  }

  @override
  void stopCanData() {
    _driveSub?.cancel();
    _driveSub = null;
  }

  @override
  Stream<DriveInformationEntity> watchCanData() {
    return _driveCtrl.stream;
  }
}