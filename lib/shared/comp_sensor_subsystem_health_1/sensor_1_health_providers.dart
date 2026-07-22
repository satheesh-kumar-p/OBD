import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import 'data/sensor_1_health_mapper.dart';
import 'data/sensor_1_health_repository.dart';
import 'domain/sensor_1_health_entity.dart';
import '../../core/logger/logger.dart';

final sensor1LoggerProvider = Provider<Logger>((ref) => Logger('SENSOR_1'));

final sensor1HealthMapperProvider = Provider<Sensor1HealthMapper>((ref) => Sensor1HealthMapper());

final sensor1HealthRepoProvider = Provider<Sensor1HealthRepository>((ref) {
  final logger = ref.read(sensor1LoggerProvider);
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.read(sensor1HealthMapperProvider);

  return Sensor1HealthRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final sensor1HealthProvider = StreamProvider<Sensor1HealthEntity?>((ref) {
  final repository = ref.watch(sensor1HealthRepoProvider);
  return repository.watchCanData();
});
