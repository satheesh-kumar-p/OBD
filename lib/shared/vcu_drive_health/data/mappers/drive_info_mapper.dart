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
  static final int _messageId = 0x204;

  @override
  int get messageId => _messageId;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'rearLeftMotorFaults',
      startBit: 39,
      endBit: 46,
    ),

    const CanField<int>(
      name: 'rearRightMotorFaults',
      startBit: 31,
      endBit: 38,
    ),

    const CanField<int>(
      name: 'frontLeftMotorFaults',
      startBit: 23,
      endBit: 30,
    ),

    // Front Right Motor Faults
    const CanField<int>(
      name: 'frontRightMotorFaults',
      startBit: 15,
      endBit: 22,
    ),

    // Rear Motor Controller Faults
    const CanField<int>(
      name: 'rearMotorControllerFaults',
      startBit: 9,
      endBit: 14,
    ),

    // Front Motor Controller Faults
    const CanField<int>(
      name: 'frontMotorControllerFaults',
      startBit: 3,
      endBit: 8,
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
      frontMotorController: _buildMotorControllerInfo(
        rawValue: values['frontMotorControllerFaults'],
      ),
      rearMotorController: _buildMotorControllerInfo(
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
      overPressure: MotorControllerErrors.overPressure.isFaulty(rawValue) ? Status.fault : Status.healthy,
      underVoltage: MotorControllerErrors.underVoltage.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overTemperature: MotorControllerErrors.overTemp.isFaulty(rawValue) ? Status.fault : Status.healthy,
      canCommunication: MotorControllerErrors.canCommunication.isFaulty(rawValue) ? Status.fault : Status.healthy,
    );
  }
}