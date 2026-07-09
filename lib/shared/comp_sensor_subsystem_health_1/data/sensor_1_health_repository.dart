import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../domain/sensor_1_health_entity.dart';

class Sensor1HealthRepository implements ICanDataRepository<Sensor1HealthEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<Sensor1HealthEntity> _mapper;
  final Logger _logger;

  Sensor1HealthRepository({
    required CommManager canManager,
    required CanExtractionStrategy<Sensor1HealthEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<Sensor1HealthEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Sensor 1 Health frame', error: e, stack: st);
        return null;
      }
    });
  }
}
