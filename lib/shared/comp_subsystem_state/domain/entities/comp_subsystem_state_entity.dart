import '../../../../core/enums/subsystem_fault_state_enum.dart';

class CompSubsystemStateEntity {
  final SubsystemFaultState uhfRadio;
  final SubsystemFaultState lBandRadio;
  final SubsystemFaultState ethernetSwitchFault;
  final GnssFaultState gnssFault;
  final SubsystemFaultState imuFault;
  final SubsystemFaultState lidar2dFault;
  final SubsystemFaultState lidar3dFault;

  CompSubsystemStateEntity({
    required this.uhfRadio,
    required this.lBandRadio,
    required this.ethernetSwitchFault,
    required this.gnssFault,
    required this.imuFault,
    required this.lidar2dFault,
    required this.lidar3dFault,
  });

  @override
  String toString() {
    return 'CompSubsystemState(uhfRadioFault: $uhfRadio, lBandRadioFault: $lBandRadio, ethernetSwitchFault: $ethernetSwitchFault, gnssFault: $gnssFault, imuFault: $imuFault, lidar2dFault: $lidar2dFault, lidar3dFault: $lidar3dFault)';
  }
}
