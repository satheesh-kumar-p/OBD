import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/drive/domain/entities/drive_information_entity.dart';

import '../data/repositories/drive_information_repository_impl.dart';
import '../domain/repositories/drive_information_repository.dart';

final driveRepoProvider = Provider<DriveInformationRepository> ((ref) {
  return DriveInformationRepositoryImpl();
});

final driveInformationProvider = StreamProvider<DriveInformationEntity> ((ref) {
  final repository = ref.read(driveRepoProvider);
  return repository.watchDriveInformation();
});
