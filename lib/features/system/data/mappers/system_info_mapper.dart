import '../../../../shared/data/can_field.dart';
import '../../domain/entities/system_info_entity.dart';
import '../../enums/subsystem_status_enum.dart';

/// Parser for CAN Message 0x203 - Subsystem State
/// Declarative configuration: all bit positions in one place
class SystemInfoMapper extends CanExtractionStrategy<SystemInfoEntity> {
  static final int id = 0x203;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    // Motor Controller States (2 bits each)
    const CanField<int>(
      name: 'rearMotorControllerRaw',
      startBit: 28,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'frontMotorControllerRaw',
      startBit: 30,
      bitLength: 2,
    ),

    // Component States (2 bits each)
    const CanField<int>(
      name: 'hvBatteryRaw',
      startBit: 32,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'lvBatteryRaw',
      startBit: 34,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'lvPduRaw',
      startBit: 36,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'dcDc48vTo12vRaw',
      startBit: 38,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'dcDc12vTo5vRaw',
      startBit: 40,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'vcuRaw',
      startBit: 42,
      bitLength: 2,
    ),

    // Motor States (2 bits each)
    const CanField<int>(
      name: 'frontLeftMotorRaw',
      startBit: 44,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'rearLeftMotorRaw',
      startBit: 46,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'frontRightMotorRaw',
      startBit: 48,
      bitLength: 2,
    ),
    const CanField<int>(
      name: 'rearRightMotorRaw',
      startBit: 50,
      bitLength: 2,
    ),
  ];

  @override
  SystemInfoEntity build(Map<String, dynamic> values) {
    return SystemInfoEntity(
      // Motor controllers: ICD rear→left, front→right mapping
      leftMotorController: _rawToStatus(values['rearMotorControllerRaw']),
      rightMotorController: _rawToStatus(values['frontMotorControllerRaw']),

      // Other components
      hvBattery: _rawToStatus(values['hvBatteryRaw']),
      lvBattery: _rawToStatus(values['lvBatteryRaw']),
      lvPdu: _rawToStatus(values['lvPduRaw']),
      dcDc48v12v: _rawToStatus(values['dcDc48vTo12vRaw']),
      dcDc12v5v: _rawToStatus(values['dcDc12vTo5vRaw']),
      vcu: _rawToStatus(values['vcuRaw']),

      // Individual motors
      frontLeftMotor: _rawToStatus(values['frontLeftMotorRaw']),
      rearLeftMotor: _rawToStatus(values['rearLeftMotorRaw']),
      frontRightMotor: _rawToStatus(values['frontRightMotorRaw']),
      rearRightMotor: _rawToStatus(values['rearRightMotorRaw']),
    );
  }

  /// Convert raw 2-bit CAN value to SubsystemStatus
  /// ICD Mapping:
  /// 0 = Reserved → noCommunication
  /// 1 = No communication → noCommunication
  /// 2 = Communicating healthy → healthy
  /// 3 = Communicating not healthy → unhealthy
  SubsystemStatus _rawToStatus(int raw) {
    switch (raw) {
      case 0: // Reserved
        return SubsystemStatus.reserved;
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