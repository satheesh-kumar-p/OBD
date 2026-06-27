import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mappers/lv_pdu_load_ch5_8_mapper.dart';
import '../../domain/entities/lv_pdu_load_ch5_8_entity.dart';

class LvPduLoadCh5_8Repository implements ICanDataRepository<LvPduLoadCh5_8Entity> {
  final CommManager _canManager;
  final Logger _logger;

  final _statusCtrl = StreamController<LvPduLoadCh5_8Entity>.broadcast();
  final _mapper = LvPduVcuLoadCh5_8Mapper();
  StreamSubscription? _statusSub;

  LvPduLoadCh5_8Repository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_statusSub != null) return;
    _logger.info('Starting PDU VCU Status Channels 5-8 data stream (CAN ID: 0x${LvPduVcuLoadCh5_8Mapper.id.toRadixString(16).toUpperCase()})');

    _statusSub = _canManager
        .watchMessage(LvPduVcuLoadCh5_8Mapper.id)
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
  Stream<LvPduLoadCh5_8Entity> watchCanData() {
    return _statusCtrl.stream;
  }
}
