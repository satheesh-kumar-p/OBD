import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import 'data/sensor_2_health_mapper.dart';
import 'data/sensor_2_health_repository.dart';
import 'domain/sensor_2_health_entity.dart';
import '../../core/logger/logger.dart';

final sensor2LoggerProvider = Provider<Logger>((ref) => Logger('SENSOR_2'));

final sensor2HealthMapperProvider = Provider<Sensor2HealthMapper>((ref) => Sensor2HealthMapper());

final sensor2HealthRepoProvider = Provider<Sensor2HealthRepository>((ref) {
  final logger = ref.read(sensor2LoggerProvider);
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.read(sensor2HealthMapperProvider);

  return Sensor2HealthRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final sensor2HealthProvider = StreamProvider<Sensor2HealthEntity?>((ref) {
  final repository = ref.watch(sensor2HealthRepoProvider);
  return repository.watchCanData();
});
