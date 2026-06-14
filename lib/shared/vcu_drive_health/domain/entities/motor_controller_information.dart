import 'status.dart';

class MotorControllerInformation {
  final Status drive;
  final Status overCurrent;
  final Status overPressure;
  final Status underVoltage;
  final Status overTemperature;
  final Status canCommunication;

  const MotorControllerInformation({
    required this.drive,
    required this.overCurrent,
    required this.overPressure,
    required this.underVoltage,
    required this.overTemperature,
    required this.canCommunication,
  });

  @override
  String toString() {
    return 'MotorControllerInfo(drive: $drive, overCurrent: $overCurrent, overPressure: $overPressure, underVoltage: $underVoltage, overTemp: $overTemperature, canComm: $canCommunication)';
  }
}
