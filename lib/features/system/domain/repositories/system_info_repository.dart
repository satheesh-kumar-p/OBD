import 'dart:async';

import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../shared/domain/repositories/can_data_repository.dart';
import '../../data/mappers/system_info_mapper.dart';
import '../entities/system_info_entity.dart';

class SystemInfoRepository
    implements CanDataRepository<SystemInfoEntity> {
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

    _healthSub = _canManager
        .watchMessage(SystemInfoMapper.id)
        .listen(
          (frame) {
        final health = _mapper.parse(frame.data);

        _healthCtrl.add(health);

        _logger.debug(
          'Health Status - HV Battery: ${health.hvBattery}',
        );
      },
      onError: (e) {
        _logger.error('CAN Health Stream Error $e');
      },
    );
  }

  @override
  void stopCanData() {
    _healthSub?.cancel();
    _healthSub = null;
  }

  @override
  Stream<SystemInfoEntity> watchCanData() {
    return _healthCtrl.stream;
  }
}