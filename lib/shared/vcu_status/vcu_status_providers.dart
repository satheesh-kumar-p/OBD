import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../core/logger/logger.dart';
import 'data/vcu_status_repository.dart';
import 'domain/vcu_status_entity.dart';

final vcuStatusLoggerProvider = Provider<Logger>((ref) => Logger('VCU_STATUS'));

final vcuStatusRepoProvider = Provider<VcuStatusRepository>((ref) {
  final logger = ref.read(vcuStatusLoggerProvider);
  final canManager = ref.watch(commManagerProvider);

  return VcuStatusRepository(
    canManager: canManager,
    logger: logger,
  );
});

final vcuStatusProvider = StreamProvider<VcuStatusEntity>((ref) {
  final repository = ref.watch(vcuStatusRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
