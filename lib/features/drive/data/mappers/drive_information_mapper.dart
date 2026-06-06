import 'package:mavlink_module/dialects/ugvcustom.dart';

import '../../domain/entities/drive_information_entity.dart';
import '../../domain/entities/motor_controller_information.dart';
import '../../domain/entities/motor_information.dart';
import '../../domain/entities/status.dart';
import '../../enums/motor_controller_errors.dart';
import '../../enums/motor_errors.dart';

class DriveInformationMapper {
  DriveInformationMapper._();

  static DriveInformationEntity toDriveInfoEntity(UgvSystemInfo data) {
    return DriveInformationEntity(
      frontLeftMotor: _buildMotorInfo(data.frontLeftMotorFaults),
      frontRightMotor: _buildMotorInfo(data.frontRightMotorFaults),
      rearLeftMotor: _buildMotorInfo(data.rearLeftMotorFaults),
      rearRightMotor: _buildMotorInfo(data.rearRightMotorFaults),

      // TODO: Hardcoded scaling to constants
      leftMotorController: _buildMotorControllerInfo(
        rawValue: data.leftMcFaults,
        voltage: data.leftMcVoltage ~/ 10,
        temperature: data.leftMcTemperature,
      ),
      rightMotorController: _buildMotorControllerInfo(
        rawValue: data.rightMcFaults,
        voltage: data.rightMcVoltage ~/ 10,
        temperature: data.rightMcTemperature,
      ),
    );
  }

  static MotorInformation _buildMotorInfo(int rawValue) {
    return MotorInformation(
      overSpeed: MotorErrors.overSpeed.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overload: MotorErrors.overload.isFaulty(rawValue) ? Status.fault : Status.healthy,
      phaseLoss: MotorErrors.phaseLoss.isFaulty(rawValue) ? Status.fault : Status.healthy,
      brake: MotorErrors.brake.isFaulty(rawValue) ? Status.fault : Status.healthy,
      encoderFault: MotorErrors.encoderFault.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overTemp: MotorErrors.overTemp.isFaulty(rawValue) ? Status.fault : Status.healthy,
      hallFault: MotorErrors.hallFault.isFaulty(rawValue) ? Status.fault : Status.healthy,
      stalled: MotorErrors.stalled.isFaulty(rawValue) ? Status.fault : Status.healthy,
    );
  }

  static MotorControllerInformation _buildMotorControllerInfo({
    required int rawValue,
    required int voltage,
    required int temperature,
  }) {
    return MotorControllerInformation(
      drive: MotorControllerErrors.drive.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overCurrent: MotorControllerErrors.overCurrent.isFaulty(rawValue) ? Status.fault : Status.healthy,
      underPressure: MotorControllerErrors.underPressure.isFaulty(rawValue) ? Status.fault : Status.healthy,
      underVoltage: MotorControllerErrors.underVoltage.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overTemperature: MotorControllerErrors.overTemp.isFaulty(rawValue) ? Status.fault : Status.healthy,
      canCommunication: MotorControllerErrors.canCommunication.isFaulty(rawValue) ? Status.fault : Status.healthy,
      voltage: voltage,
      temperature: temperature,
    );
  }
}
