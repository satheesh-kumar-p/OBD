import './status.dart';

class MotorControllerInformation {
  final Status drive;
  final Status overCurrent;
  final Status underPressure;
  final Status underVoltage;
  final Status overTemperature;
  final Status canCommunication;

  const MotorControllerInformation({
    required this.drive,
    required this.overCurrent,
    required this.underPressure,
    required this.underVoltage,
    required this.overTemperature,
    required this.canCommunication,
  });

  @override
  String toString() {
    return 'MotorControllerInfo(drive: $drive, overCurrent: $overCurrent, underPressure: $underPressure, underVoltage: $underVoltage, overTemp: $overTemperature, canComm: $canCommunication)';
  }
}
