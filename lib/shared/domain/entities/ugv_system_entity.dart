import '../../enums/ugv_motor_error.dart';
import '../../enums/ugv_sensor_error.dart';
import '../../enums/ugv_subsystem_status.dart';

class UgvSystemEntity {
  final UgvSubsystemStatus subsystems;
  final UgvMotorErrorSet leftMotorErrors;
  final UgvMotorErrorSet rightMotorErrors;
  final UgvSensorErrorSet sensorBusErrors;
  final int computeLoad;
  final int mainVoltage;
  final int mainCurrent;
  final int vcuFaultErrors;
  final int dropRateComm;
  final int batteryRemaining;

  const UgvSystemEntity({
    required this.subsystems,
    required this.leftMotorErrors,
    required this.rightMotorErrors,
    required this.sensorBusErrors,
    required this.computeLoad,
    required this.mainVoltage,
    required this.mainCurrent,
    required this.vcuFaultErrors,
    required this.dropRateComm,
    required this.batteryRemaining,
  });
}