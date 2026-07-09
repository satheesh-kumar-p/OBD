import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/power_health_entity.dart';

class VcuPowerSubsystemHealthRepository implements ICanDataRepository<PowerHealthEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<PowerHealthEntity> _mapper;
  final Logger _logger;

  VcuPowerSubsystemHealthRepository({
    required CommManager canManager,
    required CanExtractionStrategy<PowerHealthEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<PowerHealthEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse VCU Power Subsystem Health frame', error: e, stack: st);
        return null;
      }
    });
  }
}
