import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import 'data/sec_compute_health_mapper.dart';
import 'data/sec_compute_health_repository.dart';
import 'domain/sec_compute_health_entity.dart';

final secComputeHealthLoggerProvider = Provider<Logger>((ref) => Logger('SEC_COMP_HEALTH'));

final secComputeHealthMapperProvider = Provider<SecComputeHealthMapper>((ref) => SecComputeHealthMapper());

final secComputeHealthRepoProvider = Provider<SecComputeHealthRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(secComputeHealthMapperProvider);
  final logger = ref.read(secComputeHealthLoggerProvider);

  return SecComputeHealthRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final secComputeHealthProvider = StreamProvider<SecComputeHealthEntity?>((ref) {
  final repository = ref.watch(secComputeHealthRepoProvider);
  return repository.watchCanData();
});
