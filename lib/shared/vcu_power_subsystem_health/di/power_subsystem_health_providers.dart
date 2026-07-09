import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/mappers/vcu_power_subsystem_health_mapper.dart';
import '../data/repositories/vcu_power_subsystem_health_repository.dart';
import '../domain/entities/power_health_entity.dart';
import '../../../core/logger/logger.dart';

final powerHealthLoggerProvider = Provider<Logger>((ref) => Logger('POWER_HEALTH'));

final powerSubsystemHealthMapperProvider = Provider<VcuPowerSubsystemHealthMapper>((ref) => VcuPowerSubsystemHealthMapper());

final powerSubsystemHealthRepoProvider = Provider<VcuPowerSubsystemHealthRepository>((ref) {
  final logger = ref.read(powerHealthLoggerProvider);
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.read(powerSubsystemHealthMapperProvider);

  return VcuPowerSubsystemHealthRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final powerSubsystemHealthProvider = StreamProvider<PowerHealthEntity?>((ref) {
  final repository = ref.watch(powerSubsystemHealthRepoProvider);
  return repository.watchCanData();
});
