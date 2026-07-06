import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../core/logger/logger.dart';
import 'data/vcu_status_mapper.dart';
import 'data/vcu_status_repository.dart';
import 'domain/vcu_status_entity.dart';

final vcuStatusLoggerProvider = Provider<Logger>((ref) => Logger('VCU_STATUS'));

final vcuStatusMapperProvider = Provider<VcuStatusMapper>((ref) => VcuStatusMapper());

final vcuStatusRepoProvider = Provider<VcuStatusRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(vcuStatusMapperProvider);
  final logger = ref.read(vcuStatusLoggerProvider);

  return VcuStatusRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final vcuStatusProvider = StreamProvider<VcuStatusEntity?>((ref) {
  final repository = ref.watch(vcuStatusRepoProvider);
  return repository.watchCanData();
});