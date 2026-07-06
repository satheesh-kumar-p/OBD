import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../enums/connection_state_enum.dart';
import '../../enums/link_status_enum.dart';

class CompSubsystemState {
  final SubsystemFaultState uhfRadio;
  final SubsystemFaultState handControllerFault;
  final SubsystemFaultState gcsFault;
  final ConnectionState handControllerStatus;
  final ConnectionState gcsStatus;
  final SubsystemFaultState lBandRadio;
  final SubsystemFaultState ethernetSwitchFault;
  final SubsystemFaultState ethernetPort1Fault;
  final SubsystemFaultState ethernetPort2Fault;
  final SubsystemFaultState ethernetPort3Fault;
  final SubsystemFaultState ethernetPort4Fault;
  final SubsystemFaultState gnssFault;
  final SubsystemFaultState imuFault;
  final SubsystemFaultState lidar2dFault;
  final SubsystemFaultState lidar3dFault;
  final SubsystemFaultState cameraStreamFault;
  final LinkStatus uhfLinkStatus;
  final LinkStatus lBandLinkStatus;

  CompSubsystemState({
    required this.uhfRadio,
    required this.handControllerFault,
    required this.gcsFault,
    required this.handControllerStatus,
    required this.gcsStatus,
    required this.lBandRadio,
    required this.ethernetSwitchFault,
    required this.ethernetPort1Fault,
    required this.ethernetPort2Fault,
    required this.ethernetPort3Fault,
    required this.ethernetPort4Fault,
    required this.gnssFault,
    required this.imuFault,
    required this.lidar2dFault,
    required this.lidar3dFault,
    required this.cameraStreamFault,
    required this.uhfLinkStatus,
    required this.lBandLinkStatus,
  });

  @override
  String toString() {
    return 'CompSubsystemState(uhfRadioFault: $uhfRadio, handControllerFault: $handControllerFault, gcsFault: $gcsFault, handControllerStatus: $handControllerStatus, gcsStatus: $gcsStatus, lBandRadioFault: $lBandRadio, ethernetSwitchFault: $ethernetSwitchFault, ethernetPort1Fault: $ethernetPort1Fault, ethernetPort2Fault: $ethernetPort2Fault, ethernetPort3Fault: $ethernetPort3Fault, ethernetPort4Fault: $ethernetPort4Fault, gnssFault: $gnssFault, imuFault: $imuFault, lidar2dFault: $lidar2dFault, lidar3dFault: $lidar3dFault, cameraStreamFault: $cameraStreamFault, uhfLinkStatus: $uhfLinkStatus, lBandLinkStatus: $lBandLinkStatus)';
  }
}
