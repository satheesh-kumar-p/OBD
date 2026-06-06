import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../core/logger/logger.dart';
import '../application/use_cases/watch_ugv_mode_use_case.dart';
import '../data/repositories/ugv_system_info_repository_impl.dart';
import '../domain/entities/ugv_mode_entity.dart';
import '../domain/repositories/ugv_system_info_repository.dart';

final ugvModeLoggerProvider = Provider<Logger>((ref) => Logger('UGV_MODE'));

final ugvSystemInfoRepositoryProvider = Provider<UgvSystemInfoRepository>((ref) {
  final logger = ref.read(ugvModeLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return UgvSystemInfoRepositoryImpl(
    commManager: commManager,
    logger: logger,
  );
});

final watchUgvModeUseCaseProvider = Provider<WatchUgvModeUseCase>((ref) {
  final repo = ref.watch(ugvSystemInfoRepositoryProvider);
  return WatchUgvModeUseCase(repo);
});

final ugvModeProvider = StreamProvider.family<UgvModeEntity, String>((ref, linkId) {
  final useCase = ref.watch(watchUgvModeUseCaseProvider);
  return useCase(linkId);
});