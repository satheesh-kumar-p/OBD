import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../domain/entities/system_info_entity.dart';

/// Parser for CAN Message 0x203 - Subsystem State
/// Declarative configuration: all bit positions in one place
class SystemInfoMapper extends CanExtractionStrategy<SystemInfoEntity> {
  static final int id = 0x203;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [

    const CanField<int>(
      name: 'rearMotorController',
      startBit: 38,
      endBit: 39,
    ),
    const CanField<int>(
      name: 'frontMotorController',
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
      name: 'dcDc12vTo5v',
      startBit: 26,
      endBit: 27,
    ),
    const CanField<int>(
      name: 'hvPdu',
      startBit: 24,
      endBit: 25,
    ),

    // Motor States (ICD bits 44-51 → actual bits 33-40)
    const CanField<int>(
      name: 'frontLeftMotor',
      startBit: 22,
      endBit: 23,
    ),
    const CanField<int>(
      name: 'rearLeftMotor',
      startBit: 20,
      endBit: 21,
    ),
    const CanField<int>(
      name: 'frontRightMotor',
      startBit: 18,
      endBit: 19,
    ),
    const CanField<int>(
      name: 'rearRightMotor',
      startBit: 16,
      endBit: 17,
    ),
    const CanField<int>(
      name: 'mainCompute',
      startBit: 14,
      endBit: 15,
    ),
    const CanField<int>(
      name: 'secondaryCompute',
      startBit: 12,
      endBit: 13,
    ),
    const CanField<int>(
      name: 'vcu',
      startBit: 10,
      endBit: 11,
    ),
  ];

  @override
  SystemInfoEntity build(Map<String, dynamic> values) {
    return SystemInfoEntity(
      // Motor controllers: ICD rear→left, front→right mapping
      frontMotorController: _toStatus(values['rearMotorController']),
      rearMotorController: _toStatus(values['frontMotorController']),

      // Other components
      hvBattery: _toStatus(values['hvBattery']),
      lvBattery: _toStatus(values['lvBattery']),
      lvPdu: _toStatus(values['lvPdu']),
      dcDc48v12v: _toStatus(values['dcDc48vTo12v']),
      dcDc12v5v: _toStatus(values['dcDc12vTo5v']),
      hvPdu: _toStatus(values['hvPdu']),
      mainCompute: _toStatus(values['mainCompute']),
      secondaryCompute: _toStatus(values['secondaryCompute']),
      vcu: _toStatus(values['vcu']),

      // Individual motors
      frontLeftMotor: _toStatus(values['frontLeftMotor']),
      rearLeftMotor: _toStatus(values['rearLeftMotor']),
      frontRightMotor: _toStatus(values['frontRightMotor']),
      rearRightMotor: _toStatus(values['rearRightMotor']),
    );
  }

  SubsystemFaultState _toStatus(int value) {
    switch (value) {
      case 0:
        return SubsystemFaultState.unknown;
      case 1:
        return SubsystemFaultState.noFault;
      case 2:
        return SubsystemFaultState.faulty;
      default:
        return SubsystemFaultState.badValue;
    }
  }
}
