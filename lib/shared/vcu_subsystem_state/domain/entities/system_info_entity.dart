import '../../../../core/enums/subsystem_fault_state_enum.dart';

class SystemInfoEntity {
  final SubsystemFaultState frontMotorController;
  final SubsystemFaultState rearMotorController;
  final SubsystemFaultState hvBattery;
  final SubsystemFaultState lvBattery;
  final SubsystemFaultState lvPdu;
  final SubsystemFaultState dcDc48v12v;
  final SubsystemFaultState dcDc12v5v;
  final SubsystemFaultState hvPdu;
  final SubsystemFaultState frontLeftMotor;
  final SubsystemFaultState rearLeftMotor;
  final SubsystemFaultState frontRightMotor;
  final SubsystemFaultState rearRightMotor;
  final SubsystemFaultState compute;

  const SystemInfoEntity({
    required this.frontMotorController,
    required this.rearMotorController,
    required this.hvBattery,
    required this.lvBattery,
    required this.lvPdu,
    required this.dcDc48v12v,
    required this.dcDc12v5v,
    required this.hvPdu,
    required this.frontLeftMotor,
    required this.rearLeftMotor,
    required this.frontRightMotor,
    required this.rearRightMotor,
    required this.compute,
  });

  @override
  String toString() {
    return 'SystemInfo(\n'
        '  frontMotorController: $frontMotorController,\n'
        '  rearMotorController: $rearMotorController,\n'
        '  hvBattery: $hvBattery,\n'
        '  lvBattery: $lvBattery,\n'
        '  lvPdu: $lvPdu,\n'
        '  dcDc48v12v: $dcDc48v12v,\n'
        '  dcDc12v5v: $dcDc12v5v,\n'
        '  hvPdu: $hvPdu,\n'
        '  frontLeftMotor: $frontLeftMotor,\n'
        '  rearLeftMotor: $rearLeftMotor,\n'
        '  frontRightMotor: $frontRightMotor,\n'
        '  rearRightMotor: $rearRightMotor,\n'
        '  compute: $compute\n'
        ')';
  }
}