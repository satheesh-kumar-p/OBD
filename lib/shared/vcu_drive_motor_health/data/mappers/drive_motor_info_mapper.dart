import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/drive_motor_information_entity.dart';
import '../../domain/entities/motor_information.dart';
import '../../domain/entities/motor_status.dart';
import '../../enums/motor_errors.dart';

/// Parser for CAN Drive Information Message (Motor Faults)
/// Uses bitmask enums (MotorErrors, MotorControllerErrors) for fault extraction
class DriveMotorInfoMapper extends CanExtractionStrategy<DriveMotorInformationEntity> {
  static final int _messageId = 0x204;

  @override
  int get messageId => _messageId;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'aftPortMotorFaults',
      startBit: 39,
      endBit: 46,
    ),

    const CanField<int>(
      name: 'aftStarboardMotorFaults',
      startBit: 31,
      endBit: 38,
    ),

    const CanField<int>(
      name: 'forwardPortMotorFaults',
      startBit: 23,
      endBit: 30,
    ),

    const CanField<int>(
      name: 'forwardStarboardMotorFaults',
      startBit: 15,
      endBit: 22,
    ),

    const CanField<int>(
      name: 'aftMotorDataValid',
      startBit: 14,
      endBit: 14
    ),

    const CanField<int>(
      name: 'forwardMotorDataValid',
      startBit: 13,
      endBit: 13
    ),
  ];

  @override
  DriveMotorInformationEntity build(Map<String, dynamic> values) {
    return DriveMotorInformationEntity(
      // Motor Information using bitmask enums
      forwardPortMotor: _buildMotorInfo(values['forwardPortMotorFaults']),
      forwardStarboardMotor: _buildMotorInfo(values['forwardStarboardMotorFaults']),
      aftPortMotor: _buildMotorInfo(values['aftPortMotorFaults']),
      aftStarboardMotor: _buildMotorInfo(values['aftStarboardMotorFaults']),

      isForwardMotorValid: values['forwardMotorDataValid'] == 0,
      isAftMotorValid: values['aftMotorDataValid'] == 0,
    );
  }

  /// Build MotorInformation using MotorErrors bitmask enum
  MotorInformation _buildMotorInfo(int rawValue) {
    return MotorInformation(
      overSpeed: MotorErrors.overSpeed.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
      overload: MotorErrors.overload.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
      phaseLoss: MotorErrors.phaseLoss.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
      brake: MotorErrors.brake.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
      encoderFault: MotorErrors.encoderFault.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
      overTemp: MotorErrors.overTemp.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
      hallFault: MotorErrors.hallFault.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
      stalled: MotorErrors.stalled.isFaulty(rawValue) ? MotorStatus.fault : MotorStatus.healthy,
    );
  }
}