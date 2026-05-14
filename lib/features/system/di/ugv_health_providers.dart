import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/system/domain/entities/health_status_entity.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../../../shared/data/repositories/ugv_system_info_repository_impl.dart';
import '../../../shared/domain/repositories/ugv_system_info_repository.dart';
import '../application/usecases/watch_ugv_health_use_case.dart';


final ugvHealthLoggerProvider = Provider<Logger>((ref) => Logger('UGV_HEALTH'));

final ugvHealthRepositoryProvider = Provider<UgvSystemInfoRepository>((ref) {
  final logger = ref.read(ugvHealthLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return UgvSystemInfoRepositoryImpl(
    commManager: commManager,
    logger: logger,
  );
});

final watchUgvHealthUseCaseProvider = Provider<WatchUgvHealthUseCase>((ref) {
  return WatchUgvHealthUseCase(ref.watch(ugvHealthRepositoryProvider));
});

final ugvHealthDataProvider =
StreamProvider.family<HealthStatusEntity, String>((ref, linkId) {
  final useCase = ref.watch(watchUgvHealthUseCaseProvider);
  return useCase(linkId);
});