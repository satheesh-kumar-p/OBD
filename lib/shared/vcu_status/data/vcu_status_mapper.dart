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
      startBit: 36,
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
      name: 'towMode',
      startBit: 22,
      endBit: 23,
    ),
    const CanField<int>(
      name: 'towStatus',
      startBit: 20,
      endBit: 21,
    ),
    const CanField<int>(
      name: 'emergencyStatus',
      startBit: 18,
      endBit: 19,
    ),
    const CanField<int>(
      name: 'remoteEmergencyStatus',
      startBit: 16,
      endBit: 17,
    ),
  ];

  @override
  VcuStatusEntity build(Map<String, dynamic> parsedValues) {
    return VcuStatusEntity(
      operationalState: VcuOperationalState.fromInt(parsedValues['operationalState']),
      chargerConnected: parsedValues['chargerConnected'] == 1,
      chargingInProgress: parsedValues['chargingInProgress'] == 1,
      towModeEnabled: parsedValues['towMode'] == 1,
      towStatus: GenericState.fromInt(parsedValues['towStatus']),
      emergencyStatus: GenericState.fromInt(parsedValues['emergencyStatus']),
      remoteEmergencyStatus: GenericState.fromInt(parsedValues['remoteEmergencyStatus']),
    );
  }
}
