import 'vcu_status_enums.dart';

class VcuStatusEntity {
  final VcuOperationalState operationalState;
  final bool chargerConnected;
  final bool chargingInProgress;
  final ArmModeEnum armMode;
  final DriveModeEnum driveMode;
  final DriveModeLimitEnum driveModeLimit;
  final TowModeEnum towMode;
  final EmergencyEnum emergency;
  final EmergencyEnum remoteEmergency;
  final AutonomyModeEnum autonomyMode;
  final HoldStateEnum holdState;


  VcuStatusEntity({
    required this.operationalState,
    required this.chargerConnected,
    required this.chargingInProgress,
    required this.towMode,
    required this.armMode, 
    required this.driveMode, 
    required this.driveModeLimit, 
    required this.emergency, 
    required this.remoteEmergency, 
    required this.autonomyMode, 
    required this.holdState,
  });

  @override
  String toString() {
    return 'VcuStatus('
        'Operational: ${operationalState.label}, '
        'Charger: ${chargerConnected ? 'Connected' : 'Disconnected'}, '
        'Charging: ${chargingInProgress ? 'In Progress' : 'No'}, '
        'Arm Mode: ${armMode.label}, '
        'Drive Mode: ${driveMode.label}, '
        'Drive Limit: ${driveModeLimit.label}, '
        'Tow: ${towMode.label}, '
        'Emergency: ${emergency.label}, '
        'Remote Emergency: ${remoteEmergency.label}, '
        'Autonomy: ${autonomyMode.label}, '
        'Hold: ${holdState.label})';
  }
}
