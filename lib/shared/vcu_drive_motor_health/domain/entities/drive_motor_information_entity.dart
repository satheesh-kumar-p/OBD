import 'motor_information.dart';

class DriveMotorInformationEntity {
  // Motor
  final MotorInformation forwardPortMotor;
  final MotorInformation forwardStarboardMotor;
  final MotorInformation aftPortMotor;
  final MotorInformation aftStarboardMotor;

  // Validation flags
  final bool isForwardMotorValid;
  final bool isAftMotorValid;

  const DriveMotorInformationEntity({
    required this.forwardPortMotor,
    required this.forwardStarboardMotor,
    required this.aftPortMotor,
    required this.aftStarboardMotor,
    required this.isForwardMotorValid,
    required this.isAftMotorValid,
  });

  @override
  String toString() {
    return 'DriveInformation(\n'
        '  forwardPort: $forwardPortMotor,\n'
        '  forwardStarboard: $forwardStarboardMotor,\n'
        '  aftPort: $aftPortMotor,\n'
        '  aftStarboard: $aftStarboardMotor,\n'
        '  isForwardValid: $isForwardMotorValid,\n'
        '  isAftValid: $isAftMotorValid\n'
        ')';
  }
}
