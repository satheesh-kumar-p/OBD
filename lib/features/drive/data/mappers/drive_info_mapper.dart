import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/drive_information_entity.dart';
import '../../domain/entities/motor_controller_information.dart';
import '../../domain/entities/motor_information.dart';
import '../../domain/entities/status.dart';
import '../../enums/motor_controller_errors.dart';
import '../../enums/motor_errors.dart';

/// Parser for CAN Drive Information Message (Motor Faults)
/// Uses bitmask enums (MotorErrors, MotorControllerErrors) for fault extraction
class DriveInfoMapper extends CanExtractionStrategy<DriveInformationEntity> {
  // TODO: Set the correct CAN message ID from your ICD header
  static final int _messageId = 0x204;  // Change this to actual message ID

  @override
  int get messageId => _messageId;

  @override
  List<CanField<dynamic>> get fields => [
    // Time fields (ICD bits 11-27 → actual bits 0-16)
    const CanField<int>(
      name: 'hour',
      startBit: 0,   // 11 - 11 = 0
      endBit: 4,     // 15 - 11 = 4
    ),
    const CanField<int>(
      name: 'minute',
      startBit: 5,   // 16 - 11 = 5
      endBit: 10,    // 21 - 11 = 10
    ),
    const CanField<int>(
      name: 'second',
      startBit: 11,  // 22 - 11 = 11
      endBit: 16,    // 27 - 11 = 16
    ),

    // Rear Left Motor Faults (ICD bits 28-35 → actual bits 17-24)
    const CanField<int>(
      name: 'rearLeftMotorFaults',
      startBit: 17,  // 28 - 11 = 17
      endBit: 24,    // 35 - 11 = 24
    ),

    // Rear Right Motor Faults (ICD bits 36-43 → actual bits 25-32)
    const CanField<int>(
      name: 'rearRightMotorFaults',
      startBit: 25,  // 36 - 11 = 25
      endBit: 32,    // 43 - 11 = 32
    ),

    // Front Left Motor Faults (ICD bits 44-51 → actual bits 33-40)
    const CanField<int>(
      name: 'frontLeftMotorFaults',
      startBit: 33,  // 44 - 11 = 33
      endBit: 40,    // 51 - 11 = 40
    ),

    // Front Right Motor Faults (ICD bits 52-59 → actual bits 41-48)
    const CanField<int>(
      name: 'frontRightMotorFaults',
      startBit: 41,  // 52 - 11 = 41
      endBit: 48,    // 59 - 11 = 48
    ),

    // Rear Motor Controller Faults (ICD bits 61-66 → actual bits 50-55)
    const CanField<int>(
      name: 'rearMotorControllerFaults',
      startBit: 50,  // 61 - 11 = 50
      endBit: 55,    // 66 - 11 = 55
    ),

    // Front Motor Controller Faults (ICD bits 67-72 → actual bits 56-61)
    const CanField<int>(
      name: 'frontMotorControllerFaults',
      startBit: 56,  // 67 - 11 = 56
      endBit: 61,    // 72 - 11 = 61
    ),
  ];

  @override
  DriveInformationEntity build(Map<String, dynamic> values) {
    return DriveInformationEntity(
      // Motor Information using bitmask enums
      frontLeftMotor: _buildMotorInfo(values['frontLeftMotorFaults']),
      frontRightMotor: _buildMotorInfo(values['frontRightMotorFaults']),
      rearLeftMotor: _buildMotorInfo(values['rearLeftMotorFaults']),
      rearRightMotor: _buildMotorInfo(values['rearRightMotorFaults']),

      // Motor Controller Information using bitmask enums
      // TODO: Add voltage and temperature from another CAN message if available
      leftMotorController: _buildMotorControllerInfo(
        rawValue: values['frontMotorControllerFaults'],
      ),
      rightMotorController: _buildMotorControllerInfo(
        rawValue: values['rearMotorControllerFaults'],
      ),
    );
  }

  /// Build MotorInformation using MotorErrors bitmask enum
  MotorInformation _buildMotorInfo(int rawValue) {
    return MotorInformation(
      overSpeed: MotorErrors.overSpeed.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overload: MotorErrors.overload.isFaulty(rawValue) ? Status.fault : Status.healthy,
      phaseLoss: MotorErrors.phaseLoss.isFaulty(rawValue) ? Status.fault : Status.healthy,
      brake: MotorErrors.brake.isFaulty(rawValue) ? Status.fault : Status.healthy,
      encoderFault: MotorErrors.encoderFault.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overTemp: MotorErrors.overTemp.isFaulty(rawValue) ? Status.fault : Status.healthy,
      hallFault: MotorErrors.hallFault.isFaulty(rawValue) ? Status.fault : Status.healthy,
      stalled: MotorErrors.stalled.isFaulty(rawValue) ? Status.fault : Status.healthy,
    );
  }

  /// Build MotorControllerInformation using MotorControllerErrors bitmask enum
  MotorControllerInformation _buildMotorControllerInfo({
    required int rawValue,
  }) {
    return MotorControllerInformation(
      drive: MotorControllerErrors.drive.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overCurrent: MotorControllerErrors.overCurrent.isFaulty(rawValue) ? Status.fault : Status.healthy,
      underPressure: MotorControllerErrors.underPressure.isFaulty(rawValue) ? Status.fault : Status.healthy,
      underVoltage: MotorControllerErrors.underVoltage.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overTemperature: MotorControllerErrors.overTemp.isFaulty(rawValue) ? Status.fault : Status.healthy,
      canCommunication: MotorControllerErrors.canCommunication.isFaulty(rawValue) ? Status.fault : Status.healthy,
    );
  }
}