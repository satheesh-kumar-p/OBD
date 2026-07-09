import 'sec_compute_status_enum.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';

class SecComputeHealthEntity {
  final SecInterfaceStatus controlCanStatus;
  final SecInterfaceStatus auxCanStatus;
  final SecInterfaceStatus actCanStatus;
  final SecInterfaceStatus forwardMcSerialStatus;
  final SecInterfaceStatus aftMcSerialStatus;
  final SecInterfaceStatus ethernetStatus;
  final SecComputeStatus cpuLoadFault;
  final SecComputeStatus memoryFault;
  final SecComputeStatus storageFault;
  final SubsystemFaultState computeState;

  const SecComputeHealthEntity({
    required this.controlCanStatus,
    required this.auxCanStatus,
    required this.actCanStatus,
    required this.forwardMcSerialStatus,
    required this.aftMcSerialStatus,
    required this.ethernetStatus,
    required this.cpuLoadFault,
    required this.memoryFault,
    required this.storageFault,
    required this.computeState,
  });

  @override
  String toString() {
    return 'SecComputeHealthEntity('
        'controlCan: ${controlCanStatus.label}, '
        'auxCan: ${auxCanStatus.label}, '
        'actCan: ${actCanStatus.label}, '
        'forwardMcSerial: ${forwardMcSerialStatus.label}, '
        'aftMcSerial: ${aftMcSerialStatus.label}, '
        'eth: ${ethernetStatus.label}, '
        'cpuLoad: ${cpuLoadFault.label}, '
        'memory: ${memoryFault.label}, '
        'storage: ${storageFault.label}, '
        'state: ${computeState.label})';
  }
}
