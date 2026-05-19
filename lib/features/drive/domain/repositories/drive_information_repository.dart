import 'package:scout_obd/features/drive/domain/entities/drive_information_entity.dart';

abstract class DriveInformationRepository {

  Stream<DriveInformationEntity> watchDriveInformation();
}