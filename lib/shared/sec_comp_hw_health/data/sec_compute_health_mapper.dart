import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../domain/sec_compute_health_entity.dart';

class SecComputeHealthMapper extends CanExtractionStrategy<SecComputeHealthEntity> {
  static final int id = 0x225;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'stat_control_can',
      startBit: 46,
      endBit: 46,
    ),
    const CanField<int>(
      name: 'state_aux_can',
      startBit: 45,
      endBit: 45,
    ),
    const CanField<int>(
      name: 'stat_act_can',
      startBit: 44,
      endBit: 44,
    ),
    const CanField<int>(
      name: 'stat_forward_mc_serial',
      startBit: 43,
      endBit: 43,
    ),
    const CanField<int>(
      name: 'stat_aft_mc_serial',
      startBit: 42,
      endBit: 42,
    ),
    const CanField<int>(
      name: 'stat_eth',
      startBit: 41,
      endBit: 41,
    ),
    const CanField<int>(
      name: 'cpu_load_fault',
      startBit: 40,
      endBit: 40,
    ),
    const CanField<int>(
      name: 'memory_fault',
      startBit: 39,
      endBit: 39,
    ),
    const CanField<int>(
      name: 'storage_fault',
      startBit: 38,
      endBit: 38,
    ),
    const CanField<int>(
      name: 'sec_comp_state',
      startBit: 36,
      endBit: 37,
    ),
  ];

  @override
  SecComputeHealthEntity build(Map<String, dynamic> values) {
    return SecComputeHealthEntity(
      controlCanStatus: SubsystemFaultState.fromInt(values['stat_control_can']),
      auxCanStatus: SubsystemFaultState.fromInt(values['state_aux_can']),
      actCanStatus: SubsystemFaultState.fromInt(values['stat_act_can']),
      forwardMcSerialStatus: SubsystemFaultState.fromInt(values['stat_forward_mc_serial']),
      aftMcSerialStatus: SubsystemFaultState.fromInt(values['stat_aft_mc_serial']),
      ethernetStatus: SubsystemFaultState.fromInt(values['stat_eth']),
      cpuLoadFault: SubsystemFaultState.fromInt(values['cpu_load_fault']),
      memoryFault: SubsystemFaultState.fromInt(values['memory_fault']),
      storageFault: SubsystemFaultState.fromInt(values['storage_fault']),
      computeState: SubsystemFaultState.fromInt(values['sec_comp_state']),
    );
  }
}