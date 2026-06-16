import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/system_info_repository.dart';
import '../domain/entities/system_info_entity.dart';

final systemLoggerProvider =
Provider<Logger>((ref) => Logger('HEALTH'));

final systemInfoRepoProvider =
Provider<SystemInfoRepository>((ref) {
  final logger = ref.read(systemLoggerProvider);
  final canManager = ref.watch(commManagerProvider);

  return SystemInfoRepository(
    canManager: canManager,
    logger: logger,
  );
});

final systemInfoProvider =
StreamProvider<SystemInfoEntity>((ref) {
  final repository = ref.watch(systemInfoRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
