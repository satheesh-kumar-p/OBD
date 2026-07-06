import 'dart:async';

import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/mc_temp_volt_entity.dart';
import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';

class McTempVoltRepository implements ICanDataRepository<McTempVoltEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<McTempVoltEntity> _mapper;
  final Logger _logger;

  McTempVoltRepository({
    required CommManager canManager,
    required CanExtractionStrategy<McTempVoltEntity> mapper,
    required Logger logger,
  }) : _canManager = canManager,
       _mapper = mapper,
       _logger = logger;

  @override
  Stream<McTempVoltEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;
      
      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse MC Temp Volt frame', error: e, stack: st);
        return null;
      }
    });
  }
}
