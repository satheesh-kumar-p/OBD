import 'package:scout_obd/features/drive/domain/entities/drive_information_entity.dart';
import 'package:scout_obd/shared/domain/repositories/ugv_system_info_repository.dart';

class WatchDriveInformationUseCase {

  WatchDriveInformationUseCase(this._repository);

  final UgvSystemInfoRepository _repository;

  Stream<DriveInformationEntity> call() {
    return _repository.watchDriveInformation();
  }

}