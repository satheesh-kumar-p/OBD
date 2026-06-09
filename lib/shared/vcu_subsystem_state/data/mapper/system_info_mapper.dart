import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_status_enum.dart';
import '../../domain/entities/system_info_entity.dart';

/// Parser for CAN Message 0x203 - Subsystem State
/// Declarative configuration: all bit positions in one place
class SystemInfoMapper extends CanExtractionStrategy<SystemInfoEntity> {
  static final int id = 0x203;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [

    // Motor Controller States (ICD bits 28-31 → actual bits 17-20)
    const CanField<int>(
      name: 'rearMotorController',
      startBit: 17,  // 28 - 11 = 17
      endBit: 18,    // 29 - 11 = 18
    ),
    const CanField<int>(
      name: 'frontMotorController',
      startBit: 19,  // 30 - 11 = 19
      endBit: 20,    // 31 - 11 = 20
    ),

    // Component States (ICD bits 32-43 → actual bits 21-32)
    const CanField<int>(
      name: 'hvBattery',
      startBit: 21,  // 32 - 11 = 21
      endBit: 22,    // 33 - 11 = 22
    ),
    const CanField<int>(
      name: 'lvBattery',
      startBit: 23,  // 34 - 11 = 23
      endBit: 24,    // 35 - 11 = 24
    ),
    const CanField<int>(
      name: 'lvPdu',
      startBit: 25,  // 36 - 11 = 25
      endBit: 26,    // 37 - 11 = 26
    ),
    const CanField<int>(
      name: 'dcDc48vTo12v',
      startBit: 27,  // 38 - 11 = 27
      endBit: 28,    // 39 - 11 = 28
    ),
    const CanField<int>(
      name: 'dcDc12vTo5v',
      startBit: 29,  // 40 - 11 = 29
      endBit: 30,    // 41 - 11 = 30
    ),
    const CanField<int>(
      name: 'vcu',
      startBit: 31,  // 42 - 11 = 31
      endBit: 32,    // 43 - 11 = 32
    ),

    // Motor States (ICD bits 44-51 → actual bits 33-40)
    const CanField<int>(
      name: 'frontLeftMotor',
      startBit: 33,  // 44 - 11 = 33
      endBit: 34,    // 45 - 11 = 34
    ),
    const CanField<int>(
      name: 'rearLeftMotor',
      startBit: 35,  // 46 - 11 = 35
      endBit: 36,    // 47 - 11 = 36
    ),
    const CanField<int>(
      name: 'frontRightMotor',
      startBit: 37,  // 48 - 11 = 37
      endBit: 38,    // 49 - 11 = 38
    ),
    const CanField<int>(
      name: 'rearRightMotor',
      startBit: 39,  // 50 - 11 = 39
      endBit: 40,    // 51 - 11 = 40
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
      vcu: _toStatus(values['vcu']),

      // Individual motors
      frontLeftMotor: _toStatus(values['frontLeftMotor']),
      rearLeftMotor: _toStatus(values['rearLeftMotor']),
      frontRightMotor: _toStatus(values['frontRightMotor']),
      rearRightMotor: _toStatus(values['rearRightMotor']),
    );
  }

  /// Convert  2-bit CAN value to SubsystemStatus
  /// ICD Mapping:
  /// 0 = Reserved → noCommunication
  /// 1 = No communication → noCommunication
  /// 2 = Communicating healthy → healthy
  /// 3 = Communicating not healthy → unhealthy
  SubsystemStatus _toStatus(int value) {
    switch (value) {
      case 1:  // No communication
        return SubsystemStatus.noCommunication;
      case 2:  // Healthy
        return SubsystemStatus.healthy;
      case 3:  // Unhealthy/Fault
        return SubsystemStatus.unhealthy;
      default:
        return SubsystemStatus.unknown;
    }
  }
}
