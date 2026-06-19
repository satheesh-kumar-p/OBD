import 'motor_controller_information.dart';
import 'motor_information.dart';

class DriveInformationEntity {
  // Motor
  final MotorInformation frontLeftMotor;
  final MotorInformation frontRightMotor;
  final MotorInformation rearLeftMotor;
  final MotorInformation rearRightMotor;

  // Motor Controller
  final MotorControllerInformation frontMotorController;
  final MotorControllerInformation rearMotorController;

  // Validation flags
  final bool isFrontValid;
  final bool isRearValid;

  const DriveInformationEntity({
    required this.frontLeftMotor,
    required this.frontRightMotor,
    required this.rearLeftMotor,
    required this.rearRightMotor,
    required this.frontMotorController,
    required this.rearMotorController,
    required this.isFrontValid,
    required this.isRearValid,
  });

  @override
  String toString() {
    return 'DriveInformation(\n'
        '  frontLeft: $frontLeftMotor,\n'
        '  frontRight: $frontRightMotor,\n'
        '  rearLeft: $rearLeftMotor,\n'
        '  rearRight: $rearRightMotor,\n'
        '  frontMC: $frontMotorController,\n'
        '  rearMC: $rearMotorController,\n'
        '  isFrontValid: $isFrontValid,\n'
        '  isRearValid: $isRearValid\n'
        ')';
  }
}
