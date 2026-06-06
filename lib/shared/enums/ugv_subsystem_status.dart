import 'ugv_sub_system.dart';

class UgvSubsystemStatus {
  final Set<UgvSubsystem> present;
  final Set<UgvSubsystem> enabled;
  final Set<UgvSubsystem> healthy;

  UgvSubsystemStatus({
    required this.present,
    required this.enabled,
    required this.healthy,
  });

  factory UgvSubsystemStatus.fromRaw({
    required int presentBitmask,
    required int enabledBitmask,
    required int healthyBitmask,
  }) {
    return UgvSubsystemStatus(
      present: UgvSubsystem.fromBitmask(presentBitmask),
      enabled: UgvSubsystem.fromBitmask(enabledBitmask),
      healthy: UgvSubsystem.fromBitmask(healthyBitmask),
    );
  }
}