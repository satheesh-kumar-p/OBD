import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mappers/lv_pdu_load_ch1_4_mapper.dart';
import '../../domain/entities/lv_pdu_load_ch1_4_entity.dart';

class LvPduLoadCh14Repository implements ICanDataRepository<LvPduLoadCh14Entity> {
  final CommManager _canManager;
  final Logger _logger;

  final _statusCtrl = StreamController<LvPduLoadCh14Entity>.broadcast();
  final _mapper = LvPduLoadCh1_4Mapper();
  StreamSubscription? _statusSub;

  LvPduLoadCh14Repository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_statusSub != null) return;
    _logger.info('Starting PDU VCU Status Channels 1-4 data stream (CAN ID: 0x${LvPduLoadCh1_4Mapper.id.toRadixString(16).toUpperCase()})');

    _statusSub = _canManager
        .watchMessage(LvPduLoadCh1_4Mapper.id)
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
  Stream<LvPduLoadCh14Entity> watchCanData() {
    return _statusCtrl.stream;
  }
}
