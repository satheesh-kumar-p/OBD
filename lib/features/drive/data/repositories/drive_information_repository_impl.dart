import '../../domain/entities/drive_information_entity.dart';
import '../../domain/entities/motor_controller_information.dart';
import '../../domain/entities/motor_information.dart';
import '../../domain/entities/status.dart';
import '../../domain/repositories/drive_information_repository.dart';

class DriveInformationRepositoryImpl implements DriveInformationRepository {
  // TODO: Implement Logging

  @override
  Stream<DriveInformationEntity> watchDriveInformation() {
    return Stream.periodic(
      const Duration(seconds: 1),
          (i) => _generateMockData(i),
    );
  }

  // Mock
  DriveInformationEntity _generateMockData(int index) {
    final bool toggle = index.isOdd;


    MotorInformation motor(Status overridingError) => MotorInformation(
      overSpeed: toggle ? Status.fault : Status.healthy,
      overload: Status.healthy,
      phaseLoss: Status.healthy,
      brake: Status.healthy,
      encoderFault: Status.healthy,
      overTemp: toggle ? Status.fault : Status.healthy,
      hallFault: Status.healthy,
      stalled: Status.healthy,
    );

    return DriveInformationEntity(
      frontLeftMotor: motor(Status.fault),
      frontRightMotor: motor(Status.healthy),
      rearLeftMotor: motor(Status.healthy),
      rearRightMotor: motor(Status.healthy),
      leftMotorController: MotorControllerInformation(
        overCurrent: Status.healthy,
        underPressure: Status.healthy,
        underVoltage: toggle ? Status.fault : Status.healthy,
        overTemperature: Status.healthy,
        canCommunication: Status.healthy,
        voltage: 24,
        temperature: 30 + (index % 20),
      ),
      rightMotorController: MotorControllerInformation(
        overCurrent: Status.healthy,
        underPressure: Status.healthy,
        underVoltage: Status.healthy,
        overTemperature: Status.healthy,
        canCommunication: toggle ? Status.fault : Status.healthy,
        voltage: 24,
        temperature: 30 + (index % 20),
      ),
    );
  }

}
