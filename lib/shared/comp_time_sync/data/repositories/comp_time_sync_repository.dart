import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/comp_time_sync_entity.dart';

class CompTimeSyncRepository implements ICanDataRepository<CompTimeSyncEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<CompTimeSyncEntity> _mapper;
  final Logger _logger;

  CompTimeSyncRepository({
    required CommManager canManager,
    required CanExtractionStrategy<CompTimeSyncEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<CompTimeSyncEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;
      
      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Time Sync frame', error: e, stack: st);
        return null;
      }
    });
  }
}
