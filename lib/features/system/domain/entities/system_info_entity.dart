import 'package:scout_obd/features/system/enums/subsystem_status_enum.dart';

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
  });

  Map<String, SubsystemStatus> get subsystemHealthMap => {
    'Forward Motor Controller': frontMotorController,
    'Rear Motor Controller': rearMotorController,
    'HV Battery': hvBattery,
    'LV Battery': lvBattery,
    'LV PDU': lvPdu,
    'DC-DC (48V to 12V)': dcDc48v12v,
    'DC-DC (12V to 5V)': dcDc12v5v,
    'VCU': vcu,
    'Forward Left Motor': frontLeftMotor,
    'Rear Left Motor': rearLeftMotor,
    'Forward Right Motor': frontRightMotor,
    'Rear Right Motor': rearRightMotor,
  };

  @override
  String toString() {
    return 'SystemInfo(\n'
        '  leftMotorController: $frontMotorController,\n'
        '  rightMotorController: $rearMotorController,\n'
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