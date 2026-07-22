import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/drive_motor_info_mapper.dart';
import '../data/repositories/drive_motor_info_repository.dart';
import '../domain/entities/drive_motor_information_entity.dart';

final driveMotorLoggerProvider = Provider<Logger>((ref) => Logger('DRIVE'));

final driveMotorMapperProvider = Provider<DriveMotorInfoMapper>((ref) => DriveMotorInfoMapper());

final driveMotorInfoRepoProvider =
Provider<DriveMotorInfoRepository>((ref) {
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(driveMotorMapperProvider);
  final logger = ref.read(driveMotorLoggerProvider);

  return DriveMotorInfoRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final driveMotorInfoProvider =
StreamProvider<DriveMotorInformationEntity?>((ref) {
  final repository = ref.watch(driveMotorInfoRepoProvider);
  return repository.watchCanData();
});