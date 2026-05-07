import '../../domain/entities/ugv_mode_entity.dart';
import '../../domain/entities/ugv_system_entity.dart';
import '../../enums/ugv_mode.dart';
import '../../enums/ugv_motor_error.dart';
import '../../enums/ugv_sensor_error.dart';
import '../../enums/ugv_subsystem_status.dart';

class UgvSystemInfoModel {
  final int ugvSubsystemPresent;
  final int ugvSubsystemEnabled;
  final int ugvSubsystemHealth;
  final int computeLoad;
  final int mainVoltage;
  final int mainCurrent;
  final int vcuFaultErrors;
  final int dropRateComm;
  final int leftMotorErrors;
  final int rightMotorErrors;
  final int sensorBusErrors;
  final int batteryRemaining;
  final int mainMode;
  final int subMode;
  final int intendedMainMode;
  final int intendedSubMode;
  final int modeChangeReason;

  const UgvSystemInfoModel({
    required this.ugvSubsystemPresent,
    required this.ugvSubsystemEnabled,
    required this.ugvSubsystemHealth,
    required this.computeLoad,
    required this.mainVoltage,
    required this.mainCurrent,
    required this.vcuFaultErrors,
    required this.dropRateComm,
    required this.leftMotorErrors,
    required this.rightMotorErrors,
    required this.sensorBusErrors,
    required this.batteryRemaining,
    required this.mainMode,
    required this.subMode,
    required this.intendedMainMode,
    required this.intendedSubMode,
    required this.modeChangeReason,
  });

  UgvSystemEntity toSystemEntity() {
    return UgvSystemEntity(
      subsystems: UgvSubsystemStatus.fromRaw(
        presentBitmask: ugvSubsystemPresent,
        enabledBitmask: ugvSubsystemEnabled,
        healthyBitmask: ugvSubsystemHealth,
      ),
      leftMotorErrors: UgvMotorErrorSet.fromBitmask(leftMotorErrors),
      rightMotorErrors: UgvMotorErrorSet.fromBitmask(rightMotorErrors),
      sensorBusErrors: UgvSensorErrorSet.fromBitmask(sensorBusErrors),
      computeLoad: computeLoad,
      mainVoltage: mainVoltage,
      mainCurrent: mainCurrent,
      vcuFaultErrors: vcuFaultErrors,
      dropRateComm: dropRateComm,
      batteryRemaining: batteryRemaining,
    );
  }

  UgvModeEntity toModeEntity() {
    return UgvModeEntity(
      mainMode: UgvMainMode.values.elementAt(mainMode),
      subMode: UgvSubMode.values.firstWhere((e) => e.value == subMode),
      intendedMainMode: UgvMainMode.values.elementAt(intendedMainMode),
      intendedSubMode: UgvSubMode.values.firstWhere((e) => e.value == intendedSubMode),
      modeChangeReason: ModeChangeReason.values.elementAt(modeChangeReason),
    );
  }


}
