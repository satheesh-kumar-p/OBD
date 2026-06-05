import 'dart:async';

import '../mappers/drive_info_mapper.dart';
import '../../domain/entities/drive_information_entity.dart';
import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../shared/domain/repositories/i_can_data_repository.dart';

class DriveInfoRepository implements ICanDataRepository<DriveInformationEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _driveCtrl = StreamController<DriveInformationEntity>.broadcast();

  final _mapper = DriveInfoMapper();

  StreamSubscription? _driveSub;

  DriveInfoRepository({
    required CanCommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_driveSub != null) return;
    _logger.info('Starting Drive Info data stream (CAN ID: 0x${_mapper.messageId.toRadixString(16).toUpperCase()})');

    _driveSub = _canManager
        .watchMessage(_mapper.messageId)
        .listen(
          (frame) {
            try {
              final driveInfo = _mapper.parse(frame.data);
              _driveCtrl.add(driveInfo);

              _logger.debug('Drive data received', context: {
                'fl_motor': driveInfo.frontLeftMotor.overSpeed,
                'fr_motor': driveInfo.frontRightMotor.overSpeed,
                'rl_motor': driveInfo.rearLeftMotor.overSpeed,
                'rr_motor': driveInfo.rearRightMotor.overSpeed,
              });
            } catch (e, st) {
              _logger.error('Failed to parse Drive Info frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN Drive Info Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_driveSub == null) return;
    _logger.info('Stopping Drive Info data stream');
    _driveSub?.cancel();
    _driveSub = null;
  }

  @override
  Stream<DriveInformationEntity> watchCanData() {
    return _driveCtrl.stream;
  }
}