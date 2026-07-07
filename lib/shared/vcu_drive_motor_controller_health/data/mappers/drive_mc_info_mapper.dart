import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/drive_mc_information_entity.dart';
import '../../domain/entities/motor_controller_information.dart';
import '../../domain/entities/status.dart';
import '../../enums/motor_controller_errors.dart';

/// Parser for CAN Drive Information Message (Motor Faults)
/// Uses bitmask enums (MotorErrors, MotorControllerErrors) for fault extraction
class DriveMcInfoMapper extends CanExtractionStrategy<DriveMcInformationEntity> {
  static final int _messageId = 0x227;

  @override
  int get messageId => _messageId;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'aftMotorControllerFaults',
      startBit: 39,
      endBit: 46,
    ),
    const CanField<int>(
      name: 'forwardMotorControllerFaults',
      startBit: 31,
      endBit: 38,
    ),
    const CanField<int>(
      name: 'aftMotorControllerDataValid',
      startBit: 30,
      endBit: 30
    ),
    const CanField<int>(
      name: 'forwardMotorControllerDataValid',
      startBit: 29,
      endBit: 29
    ),
  ];

  @override
  DriveMcInformationEntity build(Map<String, dynamic> values) {
    return DriveMcInformationEntity(
      // Motor Controller Information using bitmask enums
      forwardMotorController: _buildMotorControllerInfo(
        rawValue: values['forwardMotorControllerFaults'],
      ),
      aftMotorController: _buildMotorControllerInfo(
        rawValue: values['aftMotorControllerFaults'],
      ),
      isForwardMcValid: values['forwardMotorControllerDataValid'] == 0,
      isAftMcValid: values['aftMotorControllerDataValid'] == 0,
    );
  }

  /// Build MotorControllerInformation using MotorControllerErrors bitmask enum
  MotorControllerInformation _buildMotorControllerInfo({
    required int rawValue,
  }) {
    return MotorControllerInformation(
      drive: MotorControllerErrors.drive.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overCurrent: MotorControllerErrors.overCurrent.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overVoltage: MotorControllerErrors.overVoltage.isFaulty(rawValue) ? Status.fault : Status.healthy,
      underVoltage: MotorControllerErrors.underVoltage.isFaulty(rawValue) ? Status.fault : Status.healthy,
      uartCommunication: MotorControllerErrors.uartCommunication.isFaulty(rawValue) ? Status.fault : Status.healthy,
      dcBusVoltage: MotorControllerErrors.busVoltage.isFaulty(rawValue) ? Status.fault : Status.healthy,
      overTemperature: MotorControllerErrors.overTemp.isFaulty(rawValue) ? Status.fault : Status.healthy,
      canCommunication: MotorControllerErrors.canCommunication.isFaulty(rawValue) ? Status.fault : Status.healthy,
    );
  }
}