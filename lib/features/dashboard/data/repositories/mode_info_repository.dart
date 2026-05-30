import 'dart:async';

import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../shared/domain/repositories/can_data_repository.dart';
import '../mappers/mode_info_mapper.dart';
import '../../domain/entities/mode_entity.dart';

class ModeInfoRepository implements CanDataRepository<ModeEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _modeCtrl = StreamController<ModeEntity>.broadcast();
  final _mapper = ModeInfoMapper();

  StreamSubscription? _modeSub;

  ModeInfoRepository({
    required CanCommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_modeSub != null) return;

    _modeSub = _canManager
        .watchMessage(ModeInfoMapper.id)
        .listen(
          (frame) {
        final modeInfo = _mapper.parse(frame.data);

        _modeCtrl.add(modeInfo);

        _logger.debug(
          'Mode Info - '
              'Main: ${modeInfo.mainMode}, '
              'Sub: ${modeInfo.subMode}, '
              'Speed: ${modeInfo.speedMode}, '
              'Drive: ${modeInfo.driveMode}, '
              'Armed: ${modeInfo.armed}',
        );
      },
      onError: (e) {
        _logger.error('CAN Mode Info Stream Error $e');
      },
    );
  }

  @override
  void stopCanData() {
    _modeSub?.cancel();
    _modeSub = null;
  }

  @override
  Stream<ModeEntity> watchCanData() {
    return _modeCtrl.stream;
  }
}