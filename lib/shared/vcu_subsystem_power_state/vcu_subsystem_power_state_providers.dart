import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import 'data/vcu_subsystem_power_state_mapper.dart';
import 'data/vcu_subsystem_power_state_repository.dart';
import 'domain/vcu_subsystem_power_state_entity.dart';

final vcuSubsystemPowerStateLoggerProvider = Provider<Logger>((ref) => Logger('VCU_SUBSYSTEM_POWER'));

final vcuSubsystemPowerStateMapperProvider = Provider<VcuSubsystemPowerStateMapper>((ref) => VcuSubsystemPowerStateMapper());

final vcuSubsystemPowerStateRepoProvider =
Provider<VcuSubsystemPowerStateRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(vcuSubsystemPowerStateMapperProvider);
  final logger = ref.read(vcuSubsystemPowerStateLoggerProvider);

  return VcuSubsystemPowerStateRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final vcuSubsystemPowerStateProvider =
StreamProvider<VcuSubsystemPowerStateEntity?>((ref) {
  final repository = ref.watch(vcuSubsystemPowerStateRepoProvider);
  return repository.watchCanData();
});
