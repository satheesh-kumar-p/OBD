import '../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../core/comm/can_bus/can_field.dart';
import '../domain/vcu_interface_health_entity.dart';
import '../domain/vcu_fault_state_enum.dart';
import '../domain/vcu_can_status_enum.dart';

class VcuInterfaceHealthMapper extends CanExtractionStrategy<VcuInterfaceHealthEntity> {
  static final int id = 0x213;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'canCBusOff', startBit: 46, endBit: 46),
    const CanField<int>(name: 'canABusOff', startBit: 45, endBit: 45),
    const CanField<int>(name: 'canBBusOff', startBit: 44, endBit: 44),
    const CanField<int>(name: 'discreteInputsFault', startBit: 43, endBit: 43),
    const CanField<int>(name: 'analogInputsFault', startBit: 42, endBit: 42),
    const CanField<int>(name: 'highSideDriversFault', startBit: 41, endBit: 41),
    const CanField<int>(name: 'lowSideDriversFault', startBit: 40, endBit: 40),
    const CanField<int>(name: 'supplyVoltageFault', startBit: 39, endBit: 39),
    const CanField<int>(name: 'mcuWatchdogFault', startBit: 38, endBit: 38),
    const CanField<int>(name: 'cpuOverload', startBit: 37, endBit: 37),
    const CanField<int>(name: 'ramFault', startBit: 36, endBit: 36),
    const CanField<int>(name: 'flashCrcFailure', startBit: 35, endBit: 35),
    const CanField<int>(name: 'fccActive', startBit: 34, endBit: 34),
    const CanField<int>(name: 'safetySbcFault', startBit: 33, endBit: 33),
    const CanField<int>(name: 'internalTempFault', startBit: 32, endBit: 32),
    const CanField<int>(name: 'bootFailure', startBit: 31, endBit: 31),
  ];

  @override
  VcuInterfaceHealthEntity build(Map<String, dynamic> parsedValues) {
    return VcuInterfaceHealthEntity(
      canCBusOff: VcuCanStatus.fromInt(parsedValues['canCBusOff']),
      canABusOff: VcuCanStatus.fromInt(parsedValues['canABusOff']),
      canBBusOff: VcuCanStatus.fromInt(parsedValues['canBBusOff']),
      discreteInputsFault: VcuFaultState.fromInt(parsedValues['discreteInputsFault']),
      analogInputsFault: VcuFaultState.fromInt(parsedValues['analogInputsFault']),
      highSideDriversFault: VcuFaultState.fromInt(parsedValues['highSideDriversFault']),
      lowSideDriversFault: VcuFaultState.fromInt(parsedValues['lowSideDriversFault']),
      supplyVoltageFault: VcuFaultState.fromInt(parsedValues['supplyVoltageFault']),
      mcuWatchdogFault: VcuFaultState.fromInt(parsedValues['mcuWatchdogFault']),
      cpuOverload: VcuFaultState.fromInt(parsedValues['cpuOverload']),
      ramFault: VcuFaultState.fromInt(parsedValues['ramFault']),
      flashCrcFailure: VcuFaultState.fromInt(parsedValues['flashCrcFailure']),
      fccActive: VcuFaultState.fromInt(parsedValues['fccActive']),
      safetySbcFault: VcuFaultState.fromInt(parsedValues['safetySbcFault']),
      internalTempFault: VcuFaultState.fromInt(parsedValues['internalTempFault']),
      bootFailure: VcuFaultState.fromInt(parsedValues['bootFailure']),
    );
  }
}
