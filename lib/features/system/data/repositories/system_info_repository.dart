import 'dart:async';

import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../shared/domain/repositories/i_can_data_repository.dart';
import '../../data/mappers/system_info_mapper.dart';
import '../../domain/entities/system_info_entity.dart';

class SystemInfoRepository implements ICanDataRepository<SystemInfoEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _healthCtrl =
  StreamController<SystemInfoEntity>.broadcast();

  final _mapper = SystemInfoMapper();

  StreamSubscription? _healthSub;

  SystemInfoRepository({
    required CanCommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_healthSub != null) return;
    _logger.info('Starting System Health data stream (CAN ID: 0x${SystemInfoMapper.id.toRadixString(16).toUpperCase()})');

    _healthSub = _canManager
        .watchMessage(SystemInfoMapper.id)
        .listen(
          (frame) {
            try {
              final health = _mapper.parse(frame.data);
              _healthCtrl.add(health);

              _logger.debug('System Health data received', context: {
                'hv_batt': health.hvBattery,
                'vcu': health.vcu,
                'pdu': health.lvPdu,
              });
            } catch (e, st) {
              _logger.error('Failed to parse System Health frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN System Health Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_healthSub == null) return;
    _logger.info('Stopping System Health data stream');
    _healthSub?.cancel();
    _healthSub = null;
  }

  @override
  Stream<SystemInfoEntity> watchCanData() {
    return _healthCtrl.stream;
  }
}