import 'vcu_fault_state_enum.dart';
import 'vcu_can_status_enum.dart';

class VcuInterfaceHealthEntity {
  final VcuCanStatus canCBusOff;
  final VcuCanStatus canABusOff;
  final VcuCanStatus canBBusOff;
  final VcuFaultState discreteInputsFault;
  final VcuFaultState analogInputsFault;
  final VcuFaultState highSideDriversFault;
  final VcuFaultState lowSideDriversFault;
  final VcuFaultState supplyVoltageFault;
  final VcuFaultState mcuWatchdogFault;
  final VcuFaultState cpuOverload;
  final VcuFaultState ramFault;
  final VcuFaultState flashCrcFailure;
  final VcuFaultState fccActive;
  final VcuFaultState safetySbcFault;
  final VcuFaultState internalTempFault;
  final VcuFaultState bootFailure;

  VcuInterfaceHealthEntity({
    required this.canCBusOff,
    required this.canABusOff,
    required this.canBBusOff,
    required this.discreteInputsFault,
    required this.analogInputsFault,
    required this.highSideDriversFault,
    required this.lowSideDriversFault,
    required this.supplyVoltageFault,
    required this.mcuWatchdogFault,
    required this.cpuOverload,
    required this.ramFault,
    required this.flashCrcFailure,
    required this.fccActive,
    required this.safetySbcFault,
    required this.internalTempFault,
    required this.bootFailure,
  });

  @override
  String toString() {
    return 'VcuInterfaceHealthEntity(canCBusOff: $canCBusOff, canABusOff: $canABusOff, canBBusOff: $canBBusOff, discreteInputsFault: $discreteInputsFault, analogInputsFault: $analogInputsFault, highSideDriversFault: $highSideDriversFault, lowSideDriversFault: $lowSideDriversFault, supplyVoltageFault: $supplyVoltageFault, mcuWatchdogFault: $mcuWatchdogFault, cpuOverload: $cpuOverload, ramFault: $ramFault, flashCrcFailure: $flashCrcFailure, fccActive: $fccActive, safetySbcFault: $safetySbcFault, internalTempFault: $internalTempFault, bootFailure: $bootFailure)';
  }
}
