import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../domain/entities/vcu_subsystem_info_entity.dart';

class VcuSubsystemStateMapper extends CanExtractionStrategy<VcuSubsystemInfoEntity> {
  static final int id = 0x203;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'aftMotorController',
      startBit: 38,
      endBit: 39,
    ),
    const CanField<int>(
      name: 'forwardMotorController',
      startBit: 36,
      endBit: 37,
    ),
    const CanField<int>(
      name: 'hvBattery',
      startBit: 34,
      endBit: 35,
    ),
    const CanField<int>(
      name: 'lvBattery',
      startBit: 32,
      endBit: 33,
    ),
    const CanField<int>(
      name: 'lvPdu',
      startBit: 30,
      endBit: 31,
    ),
    const CanField<int>(
      name: 'dcDc48vTo12v',
      startBit: 28,
      endBit: 29,
    ),
    const CanField<int>(
      name: 'hvPdu',
      startBit: 26,
      endBit: 27,
    ),
    const CanField<int>(
      name: 'forwardPortMotor',
      startBit: 24,
      endBit: 25,
    ),
    const CanField<int>(
      name: 'aftPortMotor',
      startBit: 22,
      endBit: 23,
    ),
    const CanField<int>(
      name: 'forwardStarboardMotor',
      startBit: 20,
      endBit: 21,
    ),
    const CanField<int>(
      name: 'aftStarboardMotor',
      startBit: 18,
      endBit: 19,
    ),
    const CanField<int>(
      name: 'mainCompute',
      startBit: 16,
      endBit: 17,
    ),
    const CanField<int>(
      name: 'lvBatteryCharger',
      startBit: 14,
      endBit: 15,
    ),
    const CanField<int>(
      name: 'vcu',
      startBit: 12,
      endBit: 13,
    ),
  ];

  @override
  VcuSubsystemInfoEntity build(Map<String, dynamic> values) {
    return VcuSubsystemInfoEntity(
      forwardMotorController: SubsystemFaultState.fromInt(values['forwardMotorController']),
      aftMotorController: SubsystemFaultState.fromInt(values['aftMotorController']),
      hvBattery: SubsystemFaultState.fromInt(values['hvBattery']),
      lvBattery: SubsystemFaultState.fromInt(values['lvBattery']),
      lvPdu: SubsystemFaultState.fromInt(values['lvPdu']),
      dcDc48v12v: SubsystemFaultState.fromInt(values['dcDc48vTo12v']),
      hvPdu: SubsystemFaultState.fromInt(values['hvPdu']),
      mainCompute: SubsystemFaultState.fromInt(values['mainCompute']),
      vcu: SubsystemFaultState.fromInt(values['vcu']),
      forwardPortMotor: SubsystemFaultState.fromInt(values['forwardPortMotor']),
      aftPortMotor: SubsystemFaultState.fromInt(values['aftPortMotor']),
      forwardStarboardMotor: SubsystemFaultState.fromInt(values['forwardStarboardMotor']),
      aftStarboardMotor: SubsystemFaultState.fromInt(values['aftStarboardMotor']),
    );
  }
}
