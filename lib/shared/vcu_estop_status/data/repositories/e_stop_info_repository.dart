import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../mapper/e_stop_info_mapper.dart';
import '../../domain/entities/e_stop_info_entity.dart';

class EStopInfoRepository implements ICanDataRepository<EStopInfoEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<EStopInfoEntity> _mapper;
  final Logger _logger;

  EStopInfoRepository({
    required CommManager canManager,
    required CanExtractionStrategy<EStopInfoEntity> mapper,
    required Logger logger,
  }) : _canManager = canManager,
       _mapper = mapper,
       _logger = logger;

  @override
  Stream<EStopInfoEntity?> watchCanData() {
    return _canManager.watchMessage(EStopInfoMapper.id).map((frame) {
      if (frame == null) return null;
      
      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse E-Stop Info frame', error: e, stack: st);
        return null;
      }
    });
  }
}
