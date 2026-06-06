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
    _logger.info('Starting Mode Info data stream (CAN ID: 0x${ModeInfoMapper.id.toRadixString(16).toUpperCase()})');

    _modeSub = _canManager
        .watchMessage(ModeInfoMapper.id)
        .listen(
          (frame) {
            try {
              final modeInfo = _mapper.parse(frame.data);
              _modeCtrl.add(modeInfo);

              _logger.debug('Mode data received', context: {
                'main': modeInfo.mainMode.label,
                'sub': modeInfo.subMode.label,
                'speed': modeInfo.speedMode,
                'drive': modeInfo.driveMode.name,
                'armed': modeInfo.armed,
              });
            } catch (e, st) {
              _logger.error('Failed to parse Mode Info frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN Mode Info Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_modeSub == null) return;
    _logger.info('Stopping Mode Info data stream');
    _modeSub?.cancel();
    _modeSub = null;
  }

  @override
  Stream<ModeEntity> watchCanData() {
    return _modeCtrl.stream;
  }
}