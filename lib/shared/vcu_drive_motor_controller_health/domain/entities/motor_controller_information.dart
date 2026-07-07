import 'status.dart';

class MotorControllerInformation {
  final Status drive;
  final Status overCurrent;
  final Status overVoltage;
  final Status underVoltage;
  final Status uartCommunication;
  final Status dcBusVoltage;
  final Status overTemperature;
  final Status canCommunication;

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
