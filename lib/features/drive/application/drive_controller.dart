import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/vcu_drive_health/di/drive_info_providers.dart';
import '../../../shared/vcu_drive_health/domain/entities/drive_information_entity.dart';

class DriveController extends Notifier<AsyncValue<DriveInformationEntity>> {
  @override
  AsyncValue<DriveInformationEntity> build() {
    return ref.watch(driveInfoProvider);
  }
}

final driveControllerProvider = NotifierProvider<DriveController, AsyncValue<DriveInformationEntity>>(DriveController.new);
