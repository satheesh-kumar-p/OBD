import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import 'vcu_status_mapper.dart';
import '../domain/vcu_status_entity.dart';

class VcuStatusRepository implements ICanDataRepository<VcuStatusEntity> {
  final CommManager _canManager;
  final Logger _logger;

  final _statusCtrl = StreamController<VcuStatusEntity>.broadcast();
  final _mapper = VcuStatusMapper();
  StreamSubscription? _statusSub;

  VcuStatusRepository({
    required CommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
       _logger = logger;

  @override
  void startCanData() {
    if (_statusSub != null) return;
    _logger.info('Starting VCU Status data stream (CAN ID: 0x${VcuStatusMapper.id.toRadixString(16).toUpperCase()})');

    _statusSub = _canManager
        .watchMessage(VcuStatusMapper.id)
        .listen(
          (frame) {
            try {
              final vcuStatus = _mapper.parse(frame.data);
              _statusCtrl.add(vcuStatus);
              _logger.debug('VCU Status data received', context: {
                'Operational State': vcuStatus.operationalState.label,
                'Charger Connected': vcuStatus.chargerConnected,
                'Charging In Progress': vcuStatus.chargingInProgress,
              });
            } catch (e, st) {
              _logger.error('Failed to parse VCU Status frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN VCU Status Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_statusSub == null) return;
    _logger.info('Stopping VCU Status data stream');
    _statusSub?.cancel();
    _statusSub = null;
  }

  @override
  Stream<VcuStatusEntity> watchCanData() {
    return _statusCtrl.stream;
  }
}
