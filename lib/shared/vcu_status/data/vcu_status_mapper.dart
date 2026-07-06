import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../domain/vcu_status_entity.dart';
import '../domain/vcu_status_enums.dart';

class VcuStatusMapper extends CanExtractionStrategy<VcuStatusEntity> {
  static const int id = 0x219;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'operationalState',
      startBit: 38,
      endBit: 39,
    ),
    const CanField<int>(
      name: 'chargerConnected',
      startBit: 34,
      endBit: 35,
    ),
    const CanField<int>(
      name: 'chargingInProgress',
      startBit: 32,
      endBit: 33,
    ),
    const CanField<int>(
      name: 'armMode',
      startBit: 30,
      endBit: 31,
    ),
    const CanField<int>(
      name: 'driveMode',
      startBit: 26,
      endBit: 29,
    ),
    const CanField<int>(
      name: 'driveModeLimit',
      startBit: 24,
      endBit: 25,
    ),
    const CanField<int>(
      name: 'towMode',
      startBit: 22,
      endBit: 23,
    ),
    const CanField<int>(
      name: 'emergency',
      startBit: 20,
      endBit: 21,
    ),
    const CanField<int>(
      name: 'remoteEmergency',
      startBit: 18,
      endBit: 19,
    ),
    const CanField<int>(
      name: 'autonomyMode',
      startBit: 16,
      endBit: 17,
    ),
    const CanField<int>(
      name: 'holdState',
      startBit: 14,
      endBit: 15,
    ),

  ];

  @override
  VcuStatusEntity build(Map<String, dynamic> parsedValues) {
    return VcuStatusEntity(
      operationalState: VcuOperationalState.fromInt(parsedValues['operationalState']),
      chargerConnected: parsedValues['chargerConnected'] == 1,
      chargingInProgress: parsedValues['chargingInProgress'] == 1,
      towMode: TowModeEnum.fromInt(parsedValues['towMode']),
      armMode: ArmModeEnum.fromInt(parsedValues['armMode']),
      driveMode: DriveModeEnum.fromInt(parsedValues['driveMode']),
      driveModeLimit: DriveModeLimitEnum.fromInt(parsedValues['driveModeLimit']),
      emergency: EmergencyEnum.fromInt(parsedValues['emergency']),
      remoteEmergency: RemoteEmergencyEnum.fromInt(parsedValues['remoteEmergency']),
      autonomyMode: AutonomyModeEnum.fromInt(parsedValues['autonomyMode']),
      holdState: HoldStateEnum.fromInt(parsedValues['holdState']),
    );
  }
}
