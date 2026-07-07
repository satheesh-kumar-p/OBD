import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../domain/entities/comp_subsystem_state_entity.dart';

class CompSubsystemStateMapper extends CanExtractionStrategy<CompSubsystemStateEntity> {
  static const int id = 0x199;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'uhfRadioFault', startBit: 44, endBit: 45),
    const CanField<int>(name: 'lBandRadioFault', startBit: 42, endBit: 43),
    const CanField<int>(name: 'ethernetSwitchFault', startBit: 40, endBit: 41),
    const CanField<int>(name: 'gnssFault', startBit: 38, endBit: 39),
    const CanField<int>(name: 'imuFault', startBit: 36, endBit: 37),
    const CanField<int>(name: 'lidar2dFault', startBit: 34, endBit: 35),
    const CanField<int>(name: 'lidar3dFault', startBit: 32, endBit: 33),
  ];

  @override
  CompSubsystemStateEntity build(Map<String, dynamic> parsedValues) {
    return CompSubsystemStateEntity(
      uhfRadio: SubsystemFaultState.fromInt(parsedValues['uhfRadioFault']),
      lBandRadio: SubsystemFaultState.fromInt(parsedValues['lBandRadioFault']),
      ethernetSwitchFault: SubsystemFaultState.fromInt(parsedValues['ethernetSwitchFault']),
      gnssFault: GnssFaultState.fromInt(parsedValues['gnssFault']),
      imuFault: SubsystemFaultState.fromInt(parsedValues['imuFault']),
      lidar2dFault: SubsystemFaultState.fromInt(parsedValues['lidar2dFault']),
      lidar3dFault: SubsystemFaultState.fromInt(parsedValues['lidar3dFault']),
    );
  }
}
