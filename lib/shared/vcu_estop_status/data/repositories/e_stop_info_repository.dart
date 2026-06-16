import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mapper/e_stop_info_mapper.dart';
import '../../domain/entities/e_stop_info_entity.dart';

class EStopInfoRepository implements ICanDataRepository<EStopInfoEntity> {
  final CommManager _canManager;
  final Logger _logger;

  final _ctrl = StreamController<EStopInfoEntity>.broadcast();
  final _mapper = EStopInfoMapper();
  StreamSubscription? _sub;

  EStopInfoRepository({
    required CommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
       _logger = logger;

  @override
  void startCanData() {
    if (_sub != null) return;
    _logger.info('Starting E-Stop Info data stream (CAN ID: 0x${EStopInfoMapper.id.toRadixString(16).toUpperCase()})');

    _sub = _canManager
        .watchMessage(EStopInfoMapper.id)
        .listen(
          (frame) {
            try {
              final entity = _mapper.parse(frame.data);
              _ctrl.add(entity);
              _logger.debug('E-Stop data received', context: {
                'status': entity.status.label,
              });
            } catch (e, st) {
              _logger.error('Failed to parse E-Stop Info frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN E-Stop Info Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_sub == null) return;
    _logger.info('Stopping E-Stop Info data stream');
    _sub?.cancel();
    _sub = null;
  }

  @override
  Stream<EStopInfoEntity> watchCanData() {
    return _ctrl.stream;
  }
}
