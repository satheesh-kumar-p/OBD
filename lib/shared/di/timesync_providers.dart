import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/data/repositories/time_sync_repository_impl.dart';
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