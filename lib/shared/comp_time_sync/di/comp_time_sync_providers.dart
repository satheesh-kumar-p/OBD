import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/comp_time_sync_repository.dart';
import '../domain/entities/comp_time_sync_entity.dart';

final compTimeSyncLoggerProvider = Provider<Logger>((ref) => Logger('COMP_TIME_SYNC'));

final compTimeSyncRepoProvider = Provider<CompTimeSyncRepository>((ref) {
  final logger = ref.read(compTimeSyncLoggerProvider);
  final canManager = ref.watch(canManagerProvider);

  return CompTimeSyncRepository(
    canManager: canManager,
    logger: logger,
  );
});

final compTimeSyncProvider = StreamProvider<CompTimeSyncEntity>((ref) {
  final repository = ref.watch(compTimeSyncRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
