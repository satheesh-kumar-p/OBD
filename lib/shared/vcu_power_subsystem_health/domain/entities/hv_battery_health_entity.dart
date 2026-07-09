import '../../enums/power_subsystem_status.dart';

class HvBatteryHealthEntity {
  final PowerSubsystemStatus singleCellOvervoltage;
  final PowerSubsystemStatus singleCellUndervoltage;
  final PowerSubsystemStatus packOvervoltage;
  final PowerSubsystemStatus packUndervoltage;
  final PowerSubsystemStatus chargeOverTemperature;
  final PowerSubsystemStatus chargeLowTemperature;
  final PowerSubsystemStatus dischargeOverTemperature;
  final PowerSubsystemStatus dischargeLowTemperature;
  final PowerSubsystemStatus chargeOvercurrent;
  final PowerSubsystemStatus dischargeOvercurrent;
  final PowerSubsystemStatus shortCircuitProtection;
  final PowerSubsystemStatus frontDetectionIcError;
  final PowerSubsystemStatus softwareLockMos;
  final PowerSubsystemStatus cycleLifeFault;
  final PowerSubsystemStatus capacityFault;

  const HvBatteryHealthEntity({
    required this.singleCellOvervoltage,
    required this.singleCellUndervoltage,
    required this.packOvervoltage,
    required this.packUndervoltage,
    required this.chargeOverTemperature,
    required this.chargeLowTemperature,
    required this.dischargeOverTemperature,
    required this.dischargeLowTemperature,
    required this.chargeOvercurrent,
    required this.dischargeOvercurrent,
    required this.shortCircuitProtection,
    required this.frontDetectionIcError,
    required this.softwareLockMos,
    required this.cycleLifeFault,
    required this.capacityFault,
  });

  @override
  String toString() {
    return 'HvBatteryHealthEntity(\n'
        '  singleCellOvervoltage: $singleCellOvervoltage,\n'
        '  singleCellUndervoltage: $singleCellUndervoltage,\n'
        '  packOvervoltage: $packOvervoltage,\n'
        '  packUndervoltage: $packUndervoltage,\n'
        '  chargeOverTemperature: $chargeOverTemperature,\n'
        '  chargeLowTemperature: $chargeLowTemperature,\n'
        '  dischargeOverTemperature: $dischargeOverTemperature,\n'
        '  dischargeLowTemperature: $dischargeLowTemperature,\n'
        '  chargeOvercurrent: $chargeOvercurrent,\n'
        '  dischargeOvercurrent: $dischargeOvercurrent,\n'
        '  shortCircuitProtection: $shortCircuitProtection,\n'
        '  frontDetectionIcError: $frontDetectionIcError,\n'
        '  softwareLockMos: $softwareLockMos,\n'
        '  cycleLifeFault: $cycleLifeFault,\n'
        '  capacityFault: $capacityFault\n'
        ')';
  }
}
