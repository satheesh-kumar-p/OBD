import '../../enums/power_subsystem_status.dart';

class LvBatteryHealthEntity {
  final PowerSubsystemStatus deepDischarge;
  final PowerSubsystemStatus underVoltage;
  final PowerSubsystemStatus overVoltage;
  final PowerSubsystemStatus loadFault;

  const LvBatteryHealthEntity({
    required this.deepDischarge,
    required this.underVoltage,
    required this.overVoltage,
    required this.loadFault,
  });

  @override
  String toString() {
    return 'LvBatteryHealthEntity(\n'
        '  deepDischarge: $deepDischarge,\n'
        '  underVoltage: $underVoltage,\n'
        '  overVoltage: $overVoltage,\n'
        '  loadFault: $loadFault\n'
        ')';
  }
}
