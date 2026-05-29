import '../../../features/drive/domain/entities/drive_information_entity.dart';
import '../../../features/system/domain/entities/system_info_entity.dart';
import '../entities/mode_entity.dart';

abstract interface class UgvSystemInfoRepository {
  Stream<ModeEntity> watchUgvMode();

  Stream<SystemInfoEntity> watchUgvHealth();

  Stream<DriveInformationEntity> watchDriveInformation();

  void startUgvSystemInfo();

  void stopUgvSystemInfo();
}