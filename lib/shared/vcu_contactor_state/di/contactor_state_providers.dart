import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/repositories/vcu_contactor_state_repository.dart';
import '../domain/entities/vcu_contactor_state_entity.dart';
import '../../../core/logger/logger.dart';

final contactorLoggerProvider = Provider<Logger>((ref) => Logger('CONTACTOR'));

final contactorStateRepoProvider = Provider<VcuContactorStateRepository>((ref) {
  final logger = ref.read(contactorLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return VcuContactorStateRepository(
    canManager: commManager,
    logger: logger,
  );
});

final contactorStateProvider = StreamProvider<VcuContactorStateEntity>((ref) {
  final repository = ref.watch(contactorStateRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
