import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../domain/entities/comp_subsystem_state_entity.dart';
import '../../enums/connection_state_enum.dart';
import '../../enums/link_status_enum.dart';

class CompSubsystemStateMapper extends CanExtractionStrategy<CompSubsystemState> {
  static const int id = 0x199;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'uhfRadioFault', startBit: 44, endBit: 45),
    const CanField<int>(name: 'handControllerFault', startBit: 42, endBit: 43),
    const CanField<int>(name: 'gcsFault', startBit: 40, endBit: 41),
    const CanField<int>(name: 'handControllerStatus', startBit: 39, endBit: 39),
    const CanField<int>(name: 'gcsStatus', startBit: 38, endBit: 38),
    const CanField<int>(name: 'lBandRadioFault', startBit: 36, endBit: 37),
    const CanField<int>(name: 'ethernetSwitchFault', startBit: 34, endBit: 35),
    const CanField<int>(name: 'ethernetPort1Fault', startBit: 32, endBit: 33),
    const CanField<int>(name: 'ethernetPort2Fault', startBit: 30, endBit: 31),
    const CanField<int>(name: 'ethernetPort3Fault', startBit: 28, endBit: 29),
    const CanField<int>(name: 'ethernetPort4Fault', startBit: 26, endBit: 27),
    const CanField<int>(name: 'gnssFault', startBit: 24, endBit: 25),
    const CanField<int>(name: 'imuFault', startBit: 22, endBit: 23),
    const CanField<int>(name: 'lidar2dFault', startBit: 20, endBit: 21),
    const CanField<int>(name: 'lidar3dFault', startBit: 18, endBit: 19),
    const CanField<int>(name: 'cameraStreamFault', startBit: 16, endBit: 17),
    const CanField<int>(name: 'uhfLinkStatus', startBit: 8, endBit: 9),
    const CanField<int>(name: 'lBandLinkStatus', startBit: 6, endBit: 7),
  ];

  @override
  CompSubsystemState build(Map<String, dynamic> parsedValues) {
    return CompSubsystemState(
      uhfRadio: _toFaultStatus(parsedValues['uhfRadioFault']),
      handControllerFault: _toFaultStatus(parsedValues['handControllerFault']),
      gcsFault: _toFaultStatus(parsedValues['gcsFault']),
      handControllerStatus: _toConnectionState(parsedValues['handControllerStatus']),
      gcsStatus: _toConnectionState(parsedValues['gcsStatus']),
      lBandRadio: _toFaultStatus(parsedValues['lBandRadioFault']),
      ethernetSwitchFault: _toFaultStatus(parsedValues['ethernetSwitchFault']),
      ethernetPort1Fault: _toFaultStatus(parsedValues['ethernetPort1Fault']),
      ethernetPort2Fault: _toFaultStatus(parsedValues['ethernetPort2Fault']),
      ethernetPort3Fault: _toFaultStatus(parsedValues['ethernetPort3Fault']),
      ethernetPort4Fault: _toFaultStatus(parsedValues['ethernetPort4Fault']),
      gnssFault: _toFaultStatus(parsedValues['gnssFault']),
      imuFault: _toFaultStatus(parsedValues['imuFault']),
      lidar2dFault: _toFaultStatus(parsedValues['lidar2dFault']),
      lidar3dFault: _toFaultStatus(parsedValues['lidar3dFault']),
      cameraStreamFault: _toFaultStatus(parsedValues['cameraStreamFault']),
      uhfLinkStatus: _toLinkStatus(parsedValues['uhfLinkStatus']),
      lBandLinkStatus: _toLinkStatus(parsedValues['lBandLinkStatus']),
    );
  }

  SubsystemFaultState _toFaultStatus(int value) {
    switch (value) {
      case 1:
        return SubsystemFaultState.noFault;
      case 2:
        return SubsystemFaultState.faulty;
      default:
        return SubsystemFaultState.unknown;
    }
  }

  ConnectionState _toConnectionState(int value) {
    switch (value) {
      case 0:
        return ConnectionState.notConnected;
      case 1:
        return ConnectionState.connected;
      default:
        return ConnectionState.badValue;
    }
  }

  LinkStatus _toLinkStatus(int value) {
    switch (value) {
      case 0:
        return LinkStatus.disconnected;
      case 1:
        return LinkStatus.healthy;
      case 2:
        return LinkStatus.degraded;
      default:
        return LinkStatus.badValue;
    }
  }
}
