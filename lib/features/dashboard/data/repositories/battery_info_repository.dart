import 'dart:async';

import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../shared/domain/repositories/can_data_repository.dart';
import '../mappers/battery_info_mapper.dart';
import '../../domain/entities/battery_info_entity.dart';

class BatteryInfoRepository implements CanDataRepository<BatteryInfoEntity> {
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

    _batterySub = _canManager
        .watchMessage(BatteryInfoMapper.id)
        .listen(
          (frame) {
            final batteryInfo = _mapper.parse(frame.data);
            _batteryCtrl.add(batteryInfo);
            _logger.debug(
              'Battery Info - SOC: ${batteryInfo.soc}%, Voltage: ${batteryInfo.voltage}',
            );
          },
          onError: (e) {
            _logger.error('CAN Battery Info Stream Error $e');
          },
        );
  }

  @override
  void stopCanData() {
    _batterySub?.cancel();
    _batterySub = null;
  }

  @override
  Stream<BatteryInfoEntity> watchCanData() {
    return _batteryCtrl.stream;
  }
}
