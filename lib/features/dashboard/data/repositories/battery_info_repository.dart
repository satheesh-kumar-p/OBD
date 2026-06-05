import 'dart:async';

import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../mappers/battery_info_mapper.dart';
import '../../domain/entities/battery_info_entity.dart';

class BatteryInfoRepository implements ICanDataRepository<BatteryInfoEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _batteryCtrl = StreamController<BatteryInfoEntity>.broadcast();
  final _mapper = BatteryInfoMapper();
  StreamSubscription? _batterySub;

  BatteryInfoRepository({
    required CanCommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
       _logger = logger;

  @override
  void startCanData() {
    if (_batterySub != null) return;
    _logger.info('Starting Battery Info data stream (CAN ID: 0x${BatteryInfoMapper.id.toRadixString(16).toUpperCase()})');

    _batterySub = _canManager
        .watchMessage(BatteryInfoMapper.id)
        .listen(
          (frame) {
            try {
              final batteryInfo = _mapper.parse(frame.data);
              _batteryCtrl.add(batteryInfo);
              _logger.debug('Battery data received', context: {
                'HV Battery SOC': '${batteryInfo.hvBatterySoc}%',
                'LV Battery SOC': '${batteryInfo.lvBatterySoc}%'
              });
            } catch (e, st) {
              _logger.error('Failed to parse Battery Info frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN Battery Info Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_batterySub == null) return;
    _logger.info('Stopping Battery Info data stream');
    _batterySub?.cancel();
    _batterySub = null;
  }

  @override
  Stream<BatteryInfoEntity> watchCanData() {
    return _batteryCtrl.stream;
  }
}
