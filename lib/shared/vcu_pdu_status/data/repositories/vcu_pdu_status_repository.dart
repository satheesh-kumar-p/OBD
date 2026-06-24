import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mappers/vcu_pdu_status_mapper.dart';
import '../../domain/entities/vcu_pdu_status_entity.dart';

class VcuPduStatusRepository implements ICanDataRepository<VcuPduStatusEntity> {
  final CommManager _canManager;
  final Logger _logger;

  final _statusCtrl = StreamController<VcuPduStatusEntity>.broadcast();
  final _mapper = VcuPduStatusMapper();
  StreamSubscription? _statusSub;

  VcuPduStatusRepository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_statusSub != null) return;
    _logger.info('Starting VCU PDU Status data stream (CAN ID: 0x${VcuPduStatusMapper.id.toRadixString(16).toUpperCase()})');

    _statusSub = _canManager
        .watchMessage(VcuPduStatusMapper.id)
        .listen(
          (frame) {
            try {
              final status = _mapper.parse(frame.data);
              _statusCtrl.add(status);

              _logger.debug('VCU PDU Status data received');
            } catch (e, st) {
              _logger.error('Failed to parse VCU PDU Status frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN VCU PDU Status Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_statusSub == null) return;
    _logger.info('Stopping VCU PDU Status data stream');
    _statusSub?.cancel();
    _statusSub = null;
  }

  @override
  Stream<VcuPduStatusEntity> watchCanData() {
    return _statusCtrl.stream;
  }
}
