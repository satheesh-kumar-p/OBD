import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/shared/comp_subsystem_state/data/mappers/comp_subsystem_state_mapper.dart';
import '../../core/di/injection_container.dart';
import '../../core/logger/logger.dart';
import 'data/repositories/comp_subsystem_state_repository.dart';
import 'domain/entities/comp_subsystem_state_entity.dart';

final computeCommLoggerProvider = Provider<Logger>((ref) => Logger('COMP_SUBSYSTEM_INFO'));

final compSubsystemStateMapperProvider = Provider<CompSubsystemStateMapper>((ref) => CompSubsystemStateMapper());

final compSubsystemRepoProvider = Provider<CompSubsystemStateRepository>((ref) {
  final logger = ref.read(computeCommLoggerProvider);
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(compSubsystemStateMapperProvider);
  return CompSubsystemStateRepository(canManager: canManager, mapper: mapper, logger: logger);
});

final compSubsystemInfoProvider = StreamProvider<CompSubsystemState?>((ref) {
  final repository = ref.watch(compSubsystemRepoProvider);
  return repository.watchCanData();
});
