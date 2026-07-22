import 'motor_controller_information.dart';

class DriveMcInformationEntity {
  // Motor Controller
  final MotorControllerInformation forwardMotorController;
  final MotorControllerInformation aftMotorController;

  // Validation flags
  final bool isForwardMcValid;
  final bool isAftMcValid;

  const DriveMcInformationEntity({
    required this.forwardMotorController,
    required this.aftMotorController,
    required this.isForwardMcValid,
    required this.isAftMcValid,
  });

  @override
  String toString() {
    return 'DriveMcInformation(\n'
        '  forwardMC: $forwardMotorController,\n'
        '  aftMC: $aftMotorController,\n'
        '  isForwardValid: $isForwardMcValid,\n'
        '  isAftValid: $isAftMcValid\n'
        ')';
  }
}
