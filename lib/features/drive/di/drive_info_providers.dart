import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/repositories/drive_info_repository.dart';
import '../domain/entities/drive_information_entity.dart';
import '../../../core/logger/logger.dart';

final driveLoggerProvider =
Provider<Logger>((ref) => Logger('UGV_DRIVE'));

final driveInfoRepoProvider =
Provider<DriveInfoRepository>((ref) {
  final logger = ref.read(driveLoggerProvider);
  final commManager = ref.watch(canManagerProvider);

  return DriveInfoRepository(
    canManager: commManager,
    logger: logger,
  );
});

final driveInfoProvider =
StreamProvider<DriveInformationEntity>((ref) {
  final repository = ref.watch(driveInfoRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});