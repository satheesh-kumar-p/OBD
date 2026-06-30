import 'vcu_status_enums.dart';

class VcuStatusEntity {
  final VcuOperationalState operationalState;
  final bool chargerConnected;
  final bool chargingInProgress;
  final bool towModeEnabled;
  final GenericState towStatus;
  final GenericState emergencyStatus;
  final GenericState remoteEmergencyStatus;

  VcuStatusEntity({
    required this.operationalState,
    required this.chargerConnected,
    required this.chargingInProgress,
    required this.towModeEnabled,
    required this.towStatus,
    required this.emergencyStatus,
    required this.remoteEmergencyStatus,
  });

  @override
  String toString() {
    return 'VcuStatus('
        'Operational: ${operationalState.label}, '
        'Charger: ${chargerConnected ? 'Connected' : 'Disconnected'}, '
        'Charging: ${chargingInProgress ? 'In Progress' : 'No'}, '
        'Tow Mode: ${towModeEnabled ? 'Enabled' : 'Disabled'}, '
        'Tow Status: ${towStatus.label}, '
        'Emergency: ${emergencyStatus.label}, '
        'Remote Emergency: ${remoteEmergencyStatus.label})';
  }
}
