import '../../../../core/enums/subsystem_fault_state_enum.dart';

// TODO: REFACTOR class name
class SystemInfoEntity {
  final SubsystemFaultState forwardMotorController;
  final SubsystemFaultState aftMotorController;
  final SubsystemFaultState hvBattery;
  final SubsystemFaultState lvBattery;
  final SubsystemFaultState lvPdu;
  final SubsystemFaultState dcDc48v12v;
  final SubsystemFaultState hvPdu;
  final SubsystemFaultState forwardPortMotor;
  final SubsystemFaultState aftPortMotor;
  final SubsystemFaultState forwardStarboardMotor;
  final SubsystemFaultState aftStarboardMotor;
  final SubsystemFaultState mainCompute;
  final SubsystemFaultState vcu;

  const SystemInfoEntity({
    required this.forwardMotorController,
    required this.aftMotorController,
    required this.hvBattery,
    required this.lvBattery,
    required this.lvPdu,
    required this.dcDc48v12v,
    required this.hvPdu,
    required this.forwardPortMotor,
    required this.aftPortMotor,
    required this.forwardStarboardMotor,
    required this.aftStarboardMotor,
    required this.mainCompute,
    required this.vcu,
  });

  @override
  String toString() {
    return 'SystemInfo(\n'
        '  forwardMotorController: $forwardMotorController,\n'
        '  aftMotorController: $aftMotorController,\n'
        '  hvBattery: $hvBattery,\n'
        '  lvBattery: $lvBattery,\n'
        '  lvPdu: $lvPdu,\n'
        '  dcDc48v12v: $dcDc48v12v,\n'
        '  hvPdu: $hvPdu,\n'
        '  forwardPortMotor: $forwardPortMotor,\n'
        '  aftPortMotor: $aftPortMotor,\n'
        '  forwardStarboardMotor: $forwardStarboardMotor,\n'
        '  aftStarboardMotor: $aftStarboardMotor,\n'
        '  main Compute: $mainCompute,\n'
        '  vcu: $vcu\n'
        ')';
  }
}