import '../../../../core/enums/subsystem_status_enum.dart';

class SystemInfoEntity {
  final SubsystemStatus frontMotorController;
  final SubsystemStatus rearMotorController;
  final SubsystemStatus hvBattery;
  final SubsystemStatus lvBattery;
  final SubsystemStatus lvPdu;
  final SubsystemStatus dcDc48v12v;
  final SubsystemStatus dcDc12v5v;
  final SubsystemStatus vcu;
  final SubsystemStatus frontLeftMotor;
  final SubsystemStatus rearLeftMotor;
  final SubsystemStatus frontRightMotor;
  final SubsystemStatus rearRightMotor;
  final SubsystemStatus compute;

  const SystemInfoEntity({
    required this.frontMotorController,
    required this.rearMotorController,
    required this.hvBattery,
    required this.lvBattery,
    required this.lvPdu,
    required this.dcDc48v12v,
    required this.dcDc12v5v,
    required this.vcu,
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
        '  vcu: $vcu,\n'
        '  frontLeftMotor: $frontLeftMotor,\n'
        '  rearLeftMotor: $rearLeftMotor,\n'
        '  frontRightMotor: $frontRightMotor,\n'
        '  rearRightMotor: $rearRightMotor,\n'
        '  compute: $compute\n'
        ')';
  }
}