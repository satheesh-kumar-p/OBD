import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../domain/sec_compute_health_entity.dart';
import '../domain/sec_compute_status_enum.dart';

class SecComputeHealthMapper extends CanExtractionStrategy<SecComputeHealthEntity> {
  static final int id = 0x225;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'control_can', startBit: 46, endBit: 46),
    const CanField<int>(name: 'aux_can', startBit: 45, endBit: 45),
    const CanField<int>(name: 'act_can', startBit: 44, endBit: 44),
    const CanField<int>(name: 'forward_mc_serial', startBit: 43, endBit: 43),
    const CanField<int>(name: 'aft_mc_serial', startBit: 42, endBit: 42),
    const CanField<int>(name: 'ethernet', startBit: 41, endBit: 41),
    const CanField<int>(name: 'cpu_load_fault', startBit: 40, endBit: 40),
    const CanField<int>(name: 'memory_fault', startBit: 39, endBit: 39),
    const CanField<int>(name: 'storage_fault', startBit: 38, endBit: 38),
    const CanField<int>(name: 'sec_comp_state', startBit: 36, endBit: 37),
  ];

  @override
  SecComputeHealthEntity build(Map<String, dynamic> values) {
    return SecComputeHealthEntity(
      controlCanStatus: SecInterfaceStatus.fromInt(values['control_can']),
      auxCanStatus: SecInterfaceStatus.fromInt(values['aux_can']),
      actCanStatus: SecInterfaceStatus.fromInt(values['act_can']),
      forwardMcSerialStatus: SecInterfaceStatus.fromInt(values['forward_mc_serial']),
      aftMcSerialStatus: SecInterfaceStatus.fromInt(values['aft_mc_serial']),
      ethernetStatus: SecInterfaceStatus.fromInt(values['ethernet']),
      cpuLoadFault: SecComputeStatus.fromInt(values['cpu_load_fault']),
      memoryFault: SecComputeStatus.fromInt(values['memory_fault']),
      storageFault: SecComputeStatus.fromInt(values['storage_fault']),
      computeState: SubsystemFaultState.fromInt(values['sec_comp_state']),
    );
  }
}
