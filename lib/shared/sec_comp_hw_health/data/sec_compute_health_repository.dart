import 'dart:async';
import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../domain/sec_compute_health_entity.dart';

class SecComputeHealthRepository implements ICanDataRepository<SecComputeHealthEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<SecComputeHealthEntity> _mapper;
  final Logger _logger;

  SecComputeHealthRepository({
    required CommManager canManager,
    required CanExtractionStrategy<SecComputeHealthEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<SecComputeHealthEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Secondary Compute Health frame',
            error: e, stack: st);
        return null;
      }
    });
  }
}
