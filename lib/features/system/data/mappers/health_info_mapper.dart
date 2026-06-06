import 'package:mavlink_module/dialects/ugvcustom.dart';

import '../../../../shared/constants/subsystem_list_constants.dart';
import '../../domain/entities/health_status_entity.dart';
import '../../enums/subsystem_status_enum.dart';

class HealthInfoMapper {
  HealthInfoMapper._();

  static HealthStatusEntity toHealthStatusEntity(UgvSystemInfo data) {
    Map<String, SubsystemStatus> extractedData = _transformToSystemInformation(
      data,
    );

    return HealthStatusEntity(
    leftMotorController: extractedData[kSubsystems[0]]!,
    rightMotorController: extractedData[kSubsystems[1]]!,
    hvBattery: extractedData[kSubsystems[2]]!,
    lvBattery: extractedData[kSubsystems[3]]!,
    lvPdu: extractedData[kSubsystems[4]]!,
    dcDc48v12v: extractedData[kSubsystems[5]]!,
    dcDc12v5v: extractedData[kSubsystems[6]]!,
    vcu: extractedData[kSubsystems[7]]!,
    frontLeftMotor: extractedData[kSubsystems[8]]!,
    rearLeftMotor: extractedData[kSubsystems[9]]!,
    frontRightMotor: extractedData[kSubsystems[10]]!,
    rearRightMotor: extractedData[kSubsystems[11]]!,
    uhfRadio: extractedData[kSubsystems[12]]!,
    lBandRadio: extractedData[kSubsystems[13]]!,
    compute: extractedData[kSubsystems[14]]!,
    );
  }

  static Map<String, SubsystemStatus> _transformToSystemInformation(
    UgvSystemInfo data,
  ) {
    final result = <String, SubsystemStatus>{};
    var currentByte = data.subsystemHealth1;

    for (int i = 0; i < kSubsystems.length; i++) {
      final startBit = (i * 2) % 8;
      final extractedBits = (currentByte >> startBit) & 0x3;
      result[kSubsystems[i]] = _statusFromBits(extractedBits);

      if (i % 4 == 3 && i < kSubsystems.length - 1) {
        if (i == 3) {
          currentByte = data.subsystemHealth2;
        } else if (i == 7) {
          currentByte = data.subsystemHealth3;
        } else if (i == 11) {
          currentByte = data.subsystemHealth4;
        }
      }
    }

    return result;
  }

  static SubsystemStatus _statusFromBits(int bits) {
    switch (bits) {
      case 1:
        return SubsystemStatus.noCommunication;
      case 2:
        return SubsystemStatus.healthy;
      case 3:
        return SubsystemStatus.unhealthy;
      default:
        throw ArgumentError('Unknown Value for Subsystem Status: $bits');
    }
  }
}
