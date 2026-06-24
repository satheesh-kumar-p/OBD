import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../domain/entities/power_health_entity.dart';
import '../mappers/vcu_power_subsystem_health_mapper.dart';

class VcuPowerSubsystemHealthRepository implements ICanDataRepository<PowerHealthEntity> {
  final CommManager _canManager;
  final Logger _logger;

  final _healthCtrl = StreamController<PowerHealthEntity>.broadcast();
  final _mapper = VcuPowerSubsystemHealthMapper();
  StreamSubscription? _healthSub;

  VcuPowerSubsystemHealthRepository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_healthSub != null) return;
    _logger.info('Starting VCU Power Subsystem Health data stream (CAN ID: 0x${VcuPowerSubsystemHealthMapper.id.toRadixString(16).toUpperCase()})');

    _healthSub = _canManager
        .watchMessage(VcuPowerSubsystemHealthMapper.id)
        .listen(
          (frame) {
            try {
              final health = _mapper.parse(frame.data);
              _healthCtrl.add(health);

              _logger.debug('VCU Power Subsystem Health data received');
            } catch (e, st) {
              _logger.error('Failed to parse VCU Power Subsystem Health frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN VCU Power Subsystem Health Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_healthSub == null) return;
    _logger.info('Stopping VCU Power Subsystem Health data stream');
    _healthSub?.cancel();
    _healthSub = null;
  }

  @override
  Stream<PowerHealthEntity> watchCanData() {
    return _healthCtrl.stream;
  }
}
