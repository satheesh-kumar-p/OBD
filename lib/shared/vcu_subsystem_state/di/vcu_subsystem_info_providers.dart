import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mapper/vcu_subsystem_state_mapper.dart';
import '../data/repositories/vcu_subsystem_info_repository.dart';
import '../domain/entities/vcu_subsystem_info_entity.dart';

final vcuSubsystemInfoLoggerProvider = Provider<Logger>((ref) => Logger('SYSTEM_INFO'));

final vcuSubsystemInfoMapperProvider = Provider<VcuSubsystemStateMapper>((ref) => VcuSubsystemStateMapper());

final vcuSubsystemInfoRepoProvider =
Provider<VcuSubsystemInfoRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(vcuSubsystemInfoMapperProvider);
  final logger = ref.read(vcuSubsystemInfoLoggerProvider);

  return VcuSubsystemInfoRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final vcuSubsystemInfoProvider =
StreamProvider<VcuSubsystemInfoEntity?>((ref) {
  final repository = ref.watch(vcuSubsystemInfoRepoProvider);
  return repository.watchCanData();
});
