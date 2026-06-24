import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mappers/pdu_vcu_status_ch5_8_mapper.dart';
import '../../domain/entities/pdu_vcu_status_ch5_8_entity.dart';

class PduVcuStatusCh5_8Repository implements ICanDataRepository<PduVcuStatusCh5_8Entity> {
  final CommManager _canManager;
  final Logger _logger;

  final _statusCtrl = StreamController<PduVcuStatusCh5_8Entity>.broadcast();
  final _mapper = PduVcuStatusCh5_8Mapper();
  StreamSubscription? _statusSub;

  PduVcuStatusCh5_8Repository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_statusSub != null) return;
    _logger.info('Starting PDU VCU Status Channels 5-8 data stream (CAN ID: 0x${PduVcuStatusCh5_8Mapper.id.toRadixString(16).toUpperCase()})');

    _statusSub = _canManager
        .watchMessage(PduVcuStatusCh5_8Mapper.id)
        .listen(
          (frame) {
            try {
              final status = _mapper.parse(frame.data);
              _statusCtrl.add(status);

              _logger.debug('PDU VCU Status Channels 5-8 data received');
            } catch (e, st) {
              _logger.error('Failed to parse PDU VCU Status Channels 5-8 frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN PDU VCU Status Channels 5-8 Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_statusSub == null) return;
    _logger.info('Stopping PDU VCU Status Channels 5-8 data stream');
    _statusSub?.cancel();
    _statusSub = null;
  }

  @override
  Stream<PduVcuStatusCh5_8Entity> watchCanData() {
    return _statusCtrl.stream;
  }
}
