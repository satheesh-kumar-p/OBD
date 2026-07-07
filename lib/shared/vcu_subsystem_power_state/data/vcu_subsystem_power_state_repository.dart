import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../domain/vcu_subsystem_power_state_entity.dart';

class VcuSubsystemPowerStateRepository implements ICanDataRepository<VcuSubsystemPowerStateEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<VcuSubsystemPowerStateEntity> _mapper;
  final Logger _logger;

  VcuSubsystemPowerStateRepository({
    required CommManager canManager,
    required CanExtractionStrategy<VcuSubsystemPowerStateEntity> mapper,
    required Logger logger,
  }) : _canManager = canManager,
       _mapper = mapper,
       _logger = logger;

  @override
  Stream<VcuSubsystemPowerStateEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Subsystem Power State frame', error: e, stack: st);
        return null;
      }
    });
  }
}
