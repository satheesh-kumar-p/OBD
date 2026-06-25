import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../core/logger/logger.dart';
import 'data/repositories/comp_subsystem_state_repository.dart';
import 'domain/entities/comp_subsystem_state_entity.dart';

final computeCommLoggerProvider = Provider<Logger>((ref) => Logger('COMP_SUBSYSTEM_INFO'));

final compSubsystemRepoProvider = Provider<CompSubsystemStateRepository>((ref) {
  final logger = ref.read(computeCommLoggerProvider);
  final canManager = ref.watch(commManagerProvider);
  return CompSubsystemStateRepository(canManager: canManager, logger: logger);
});

final compSubsystemInfoProvider = StreamProvider<CompSubsystemState>((ref) {
  final repository = ref.watch(compSubsystemRepoProvider);
  repository.startCanData();
  ref.onDispose(() => repository.stopCanData());
  return repository.watchCanData();
});
