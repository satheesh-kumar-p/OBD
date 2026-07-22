import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/drive_mc_info_mapper.dart';
import '../data/repositories/drive_mc_info_repository.dart';
import '../domain/entities/drive_mc_information_entity.dart';

final driveMcLoggerProvider = Provider<Logger>((ref) => Logger('DRIVE'));

final driveMcMapperProvider = Provider<DriveMcInfoMapper>((ref) => DriveMcInfoMapper());

final driveMcInfoRepoProvider =
Provider<DriveMcInfoRepository>((ref) {
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(driveMcMapperProvider);
  final logger = ref.read(driveMcLoggerProvider);

  return DriveMcInfoRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final driveMcInfoProvider =
StreamProvider<DriveMcInformationEntity?>((ref) {
  final repository = ref.watch(driveMcInfoRepoProvider);
  return repository.watchCanData();
});