import 'dart:async';

import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../mappers/drive_info_mapper.dart';
import '../../domain/entities/drive_information_entity.dart';
import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';

class DriveInfoRepository implements ICanDataRepository<DriveInformationEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<DriveInformationEntity> _mapper;
  final Logger _logger;

  DriveInfoRepository({
    required CommManager canManager,
    required CanExtractionStrategy<DriveInformationEntity> mapper,
    required Logger logger,
  }) : _canManager = canManager,
       _mapper = mapper,
       _logger = logger;

  @override
  Stream<DriveInformationEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;
      
      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Drive Info frame', error: e, stack: st);
        return null;
      }
    });
  }
}