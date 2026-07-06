import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/global_time_info_entity.dart';

class GlobalTimeInfoRepository implements ICanDataRepository<GlobalTimeInfoEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<GlobalTimeInfoEntity> _mapper;
  final Logger _logger;

  GlobalTimeInfoRepository({
    required CommManager canManager,
    required CanExtractionStrategy<GlobalTimeInfoEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<GlobalTimeInfoEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;
      
      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Global Time frame', error: e, stack: st);
        return null;
      }
    });
  }
}
