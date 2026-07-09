import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/mappers/vcu_contactor_state_mapper.dart';
import '../data/repositories/vcu_contactor_state_repository.dart';
import '../domain/entities/vcu_contactor_state_entity.dart';
import '../../../core/logger/logger.dart';

final contactorLoggerProvider = Provider<Logger>((ref) => Logger('CONTACTOR'));

final contactorMapperProvider = Provider<VcuContactorStateMapper>((ref) => VcuContactorStateMapper());

final contactorStateRepoProvider = Provider<VcuContactorStateRepository>((ref) {
  final logger = ref.read(contactorLoggerProvider);
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.read(contactorMapperProvider);

  return VcuContactorStateRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final contactorStateProvider = StreamProvider<VcuContactorStateEntity?>((ref) {
  final repository = ref.watch(contactorStateRepoProvider);
  return repository.watchCanData();
});
