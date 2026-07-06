import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/comp_time_sync_mapper.dart';
import '../data/repositories/comp_time_sync_repository.dart';
import '../domain/entities/comp_time_sync_entity.dart';

final compTimeSyncLoggerProvider = Provider<Logger>((ref) => Logger('TIME_SYNC'));

final compTimeSyncMapperProvider = Provider<CompTimeSyncMapper>((ref) => CompTimeSyncMapper());

final compTimeSyncRepoProvider = Provider<CompTimeSyncRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(compTimeSyncMapperProvider);
  final logger = ref.read(compTimeSyncLoggerProvider);

  return CompTimeSyncRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final compTimeSyncProvider = StreamProvider<CompTimeSyncEntity?>((ref) {
  final repository = ref.watch(compTimeSyncRepoProvider);
  return repository.watchCanData();
});
