import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../domain/sensor_2_health_entity.dart';

class Sensor2HealthRepository implements ICanDataRepository<Sensor2HealthEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<Sensor2HealthEntity> _mapper;
  final Logger _logger;

  Sensor2HealthRepository({
    required CommManager canManager,
    required CanExtractionStrategy<Sensor2HealthEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<Sensor2HealthEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Sensor 2 Health frame', error: e, stack: st);
        return null;
      }
    });
  }
}
