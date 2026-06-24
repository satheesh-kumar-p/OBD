import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mappers/pdu_vcu_status_ch1_4_mapper.dart';
import '../../domain/entities/pdu_vcu_status_ch1_4_entity.dart';

class PduVcuStatusCh1_4Repository implements ICanDataRepository<PduVcuStatusCh1_4Entity> {
  final CommManager _canManager;
  final Logger _logger;

  final _statusCtrl = StreamController<PduVcuStatusCh1_4Entity>.broadcast();
  final _mapper = PduVcuStatusCh1_4Mapper();
  StreamSubscription? _statusSub;

  PduVcuStatusCh1_4Repository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_statusSub != null) return;
    _logger.info('Starting PDU VCU Status Channels 1-4 data stream (CAN ID: 0x${PduVcuStatusCh1_4Mapper.id.toRadixString(16).toUpperCase()})');

    _statusSub = _canManager
        .watchMessage(PduVcuStatusCh1_4Mapper.id)
        .listen(
          (frame) {
            try {
              final status = _mapper.parse(frame.data);
              _statusCtrl.add(status);

              _logger.debug('PDU VCU Status Channels 1-4 data received');
            } catch (e, st) {
              _logger.error('Failed to parse PDU VCU Status Channels 1-4 frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN PDU VCU Status Channels 1-4 Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_statusSub == null) return;
    _logger.info('Stopping PDU VCU Status Channels 1-4 data stream');
    _statusSub?.cancel();
    _statusSub = null;
  }

  @override
  Stream<PduVcuStatusCh1_4Entity> watchCanData() {
    return _statusCtrl.stream;
  }
}
