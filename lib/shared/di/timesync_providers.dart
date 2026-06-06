/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/application/use_cases/watch_system_time_use_case.dart';
import 'package:scout_obd/shared/application/use_cases/watch_time_sync_use_case.dart';
import 'package:scout_obd/shared/data/repositories/time_sync_repository_impl.dart';
import 'package:scout_obd/shared/domain/entities/system_time_entity.dart';
import 'package:scout_obd/shared/domain/entities/time_sync_entity.dart';
import 'package:scout_obd/shared/domain/repositories/time_sync_repository.dart';

final timeSyncLoggerProvider = Provider<Logger>((ref) => Logger('TIMESYNC'));

final timeSyncRepositoryProvider = Provider<TimeSyncRepository>((ref) {
  final logger = ref.read(timeSyncLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return TimeSyncRepositoryImpl(
    commManager: commManager,
    logger: logger,
  );
});

final timeSyncUseCaseProvider = Provider<WatchTimeSyncUseCase>((ref) {
  return WatchTimeSyncUseCase(ref.watch(timeSyncRepositoryProvider));
});

final timeSyncProvider =
StreamProvider.family<TimeSyncEntity, String> ((ref, linkId) {
  final useCase = ref.watch(timeSyncUseCaseProvider);
  return useCase(linkId);
});

final systemTimeUseCaseProvider = Provider<WatchSystemTimeUseCase>((ref) {
  return WatchSystemTimeUseCase(ref.watch(timeSyncRepositoryProvider));
});

final systemTimeProvider = StreamProvider.family<SystemTimeEntity, String> ((ref, linkId) {
  final useCase = ref.watch(systemTimeUseCaseProvider);
  return useCase(linkId);
});
*/
