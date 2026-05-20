import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/drive/application/use_cases/watch_drive_information_use_case.dart';
import 'package:scout_obd/shared/di/mode_providers.dart';

import '../domain/entities/drive_information_entity.dart';

final watchDriveUseCaseProvider = Provider<WatchDriveInformationUseCase> ((ref) {
  return WatchDriveInformationUseCase(ref.read(ugvSystemInfoRepositoryProvider));
});

final driveInformationProvider = StreamProvider<DriveInformationEntity> ((ref) {
  final useCase = ref.watch(watchDriveUseCaseProvider);
  return useCase();
});
