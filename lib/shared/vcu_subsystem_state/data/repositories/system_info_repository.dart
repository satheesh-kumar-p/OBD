import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../mapper/system_info_mapper.dart';
import '../../domain/entities/system_info_entity.dart';

class SystemInfoRepository implements ICanDataRepository<SystemInfoEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<SystemInfoEntity> _mapper;
  final Logger _logger;

  SystemInfoRepository({
    required CommManager canManager,
    required CanExtractionStrategy<SystemInfoEntity> mapper,
    required Logger logger,
  }) : _canManager = canManager,
       _mapper = mapper,
       _logger = logger;

  @override
  Stream<SystemInfoEntity?> watchCanData() {
    return _canManager.watchMessage(SystemInfoMapper.id).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse System Info frame', error: e, stack: st);
        return null;
      }
    });
  }
}
