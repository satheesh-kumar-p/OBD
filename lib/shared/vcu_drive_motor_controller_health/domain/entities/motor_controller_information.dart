import 'mc_status.dart';

class MotorControllerInformation {
  final McStatus drive;
  final McStatus overCurrent;
  final McStatus overVoltage;
  final McStatus underVoltage;
  final McStatus uartCommunication;
  final McStatus dcBusVoltage;
  final McStatus overTemperature;
  final McStatus canCommunication;

  const MotorControllerInformation({
    required this.overCurrent,
    required this.drive,
    required this.dcBusVoltage,
    required this.overTemperature,
    required this.canCommunication,
    required this.overVoltage,
    required this.underVoltage,
    required this.uartCommunication,
  });

  @override
  String toString() {
    return 'MotorControllerInformation('
        'drive: $drive, '
        'overCurrent: $overCurrent, '
        'overVoltage: $overVoltage, '
        'underVoltage: $underVoltage, '
        'uartCommunication: $uartCommunication, '
        'dcBusVoltage: $dcBusVoltage, '
        'overTemperature: $overTemperature, '
        'canCommunication: $canCommunication'
        ')';
  }
}
