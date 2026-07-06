import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/drive_info_mapper.dart';
import '../data/repositories/drive_info_repository.dart';
import '../domain/entities/drive_information_entity.dart';

final driveLoggerProvider = Provider<Logger>((ref) => Logger('DRIVE'));

final driveMapperProvider = Provider<DriveInfoMapper>((ref) => DriveInfoMapper());

final driveInfoRepoProvider =
Provider<DriveInfoRepository>((ref) {
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(driveMapperProvider);
  final logger = ref.read(driveLoggerProvider);

  return DriveInfoRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final driveInfoProvider =
StreamProvider<DriveInformationEntity?>((ref) {
  final repository = ref.watch(driveInfoRepoProvider);
  return repository.watchCanData();
});