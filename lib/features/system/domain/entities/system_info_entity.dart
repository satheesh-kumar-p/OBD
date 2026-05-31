import 'package:scout_obd/features/system/enums/subsystem_status_enum.dart';

class SystemInfoEntity {
  final SubsystemStatus leftMotorController;
  final SubsystemStatus rightMotorController;
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

  const SystemInfoEntity({
    required this.leftMotorController,
    required this.rightMotorController,
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
  });

  Map<String, SubsystemStatus> get subsystemHealthMap => {
    'Left Motor Controller': leftMotorController,
    'Right Motor Controller': rightMotorController,
    'HV Battery': hvBattery,
    'LV Battery': lvBattery,
    'LV PDU': lvPdu,
    'DC-DC (48V to 12V)': dcDc48v12v,
    'DC-DC (12V to 5V)': dcDc12v5v,
    'VCU': vcu,
    'Front Left Motor': frontLeftMotor,
    'Rear Left Motor': rearLeftMotor,
    'Front Right Motor': frontRightMotor,
    'Rear Right Motor': rearRightMotor,
  };

  @override
  String toString() {
    return 'SystemInfo(\n'
        '  leftMotorController: $leftMotorController,\n'
        '  rightMotorController: $rightMotorController,\n'
        '  hvBattery: $hvBattery,\n'
        '  lvBattery: $lvBattery,\n'
        '  lvPdu: $lvPdu,\n'
        '  dcDc48v12v: $dcDc48v12v,\n'
        '  dcDc12v5v: $dcDc12v5v,\n'
        '  vcu: $vcu,\n'
        '  frontLeftMotor: $frontLeftMotor,\n'
        '  rearLeftMotor: $rearLeftMotor,\n'
        '  frontRightMotor: $frontRightMotor,\n'
        '  rearRightMotor: $rearRightMotor\n'
        ')';
  }
}