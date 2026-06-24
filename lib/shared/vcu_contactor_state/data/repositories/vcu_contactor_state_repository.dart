import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mappers/vcu_contactor_state_mapper.dart';
import '../../domain/entities/vcu_contactor_state_entity.dart';

class VcuContactorStateRepository implements ICanDataRepository<VcuContactorStateEntity> {
  final CommManager _canManager;
  final Logger _logger;

  final _stateCtrl = StreamController<VcuContactorStateEntity>.broadcast();
  final _mapper = VcuContactorStateMapper();
  StreamSubscription? _stateSub;

  VcuContactorStateRepository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_stateSub != null) return;
    _logger.info('Starting VCU Contactor State data stream (CAN ID: 0x${VcuContactorStateMapper.id.toRadixString(16).toUpperCase()})');

    _stateSub = _canManager
        .watchMessage(VcuContactorStateMapper.id)
        .listen(
          (frame) {
            try {
              final state = _mapper.parse(frame.data);
              _stateCtrl.add(state);

              _logger.debug('VCU Contactor State data received');
            } catch (e, st) {
              _logger.error('Failed to parse VCU Contactor State frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN VCU Contactor State Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_stateSub == null) return;
    _logger.info('Stopping VCU Contactor State data stream');
    _stateSub?.cancel();
    _stateSub = null;
  }

  @override
  Stream<VcuContactorStateEntity> watchCanData() {
    return _stateCtrl.stream;
  }
}
