import './status.dart';

class MotorControllerInformation {
  final Status overCurrent;
  final Status underPressure;
  final Status underVoltage;
  final Status overTemperature;
  final Status canCommunication;

  final int voltage;
  final int temperature;

  const MotorControllerInformation({
    required this.overCurrent,
    required this.underPressure,
    required this.underVoltage,
    required this.overTemperature,
    required this.canCommunication,
    required this.voltage,
    required this.temperature,
  });
}
