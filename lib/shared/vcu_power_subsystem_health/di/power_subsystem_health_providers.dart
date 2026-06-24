import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/shared/vcu_power_subsystem_health/domain/entities/power_health_entity.dart';
import '../../../core/di/injection_container.dart';
import '../data/repositories/vcu_power_subsystem_health_repository.dart';
import '../../../core/logger/logger.dart';

final powerHealthLoggerProvider = Provider<Logger>((ref) => Logger('POWER_HEALTH'));

final powerSubsystemHealthRepoProvider = Provider<VcuPowerSubsystemHealthRepository>((ref) {
  final logger = ref.read(powerHealthLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return VcuPowerSubsystemHealthRepository(
    canManager: commManager,
    logger: logger,
  );
});

final powerSubsystemHealthProvider = StreamProvider<PowerHealthEntity>((ref) {
  final repository = ref.watch(powerSubsystemHealthRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
