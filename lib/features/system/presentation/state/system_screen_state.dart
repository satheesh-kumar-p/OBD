import '../../../../core/constants/subsystem_list_constants.dart';
import '../../domain/entities/system_info_entity.dart';
import '../../domain/entities/compute_comm_info_entity.dart';
import '../../enums/subsystem_status_enum.dart';

class SystemScreenState {
  final SystemInfoEntity? systemInfo;
  final DateTime? systemInfoLastUpdate;
  
  final ComputeCommInfoEntity? computeCommInfo;
  final DateTime? computeInfoLastUpdate;
  
  /// The reference time for staleness calculations in this state frame.
  final DateTime now;

  SystemScreenState({
    this.systemInfo,
    this.systemInfoLastUpdate,
    this.computeCommInfo,
    this.computeInfoLastUpdate,
    DateTime? now,
  }) : now = now ?? DateTime.now();

  SystemScreenState copyWith({
    SystemInfoEntity? systemInfo,
    DateTime? systemInfoLastUpdate,
    ComputeCommInfoEntity? computeCommInfo,
    DateTime? computeInfoLastUpdate,
    DateTime? now,
  }) {
    return SystemScreenState(
      systemInfo: systemInfo ?? this.systemInfo,
      systemInfoLastUpdate: systemInfoLastUpdate ?? this.systemInfoLastUpdate,
      computeCommInfo: computeCommInfo ?? this.computeCommInfo,
      computeInfoLastUpdate: computeInfoLastUpdate ?? this.computeInfoLastUpdate,
      now: now ?? this.now,
    );
  }

  /// Calculates the current display status for all subsystems,
  /// accounting for data staleness (5-second timeout).
  Map<Subsystem, SubsystemStatus> get subsystemStatuses {
    const staleThreshold = Duration(seconds: 5);

    final bool systemStale = systemInfoLastUpdate == null || 
        now.difference(systemInfoLastUpdate!) > staleThreshold;
    
    final bool computeStale = computeInfoLastUpdate == null || 
        now.difference(computeInfoLastUpdate!) > staleThreshold;

    return {
      Subsystem.frontMotorController: !systemStale ? systemInfo!.frontMotorController : SubsystemStatus.unknown,
      Subsystem.rearMotorController: !systemStale ? systemInfo!.rearMotorController : SubsystemStatus.unknown,
      Subsystem.hvBattery: !systemStale ? systemInfo!.hvBattery : SubsystemStatus.unknown,
      Subsystem.lvBattery: !systemStale ? systemInfo!.lvBattery : SubsystemStatus.unknown,
      Subsystem.lvPdu: !systemStale ? systemInfo!.lvPdu : SubsystemStatus.unknown,
      Subsystem.dcDc48v12v: !systemStale ? systemInfo!.dcDc48v12v : SubsystemStatus.unknown,
      Subsystem.dcDc12v5v: !systemStale ? systemInfo!.dcDc12v5v : SubsystemStatus.unknown,
      Subsystem.vcu: !systemStale ? systemInfo!.vcu : SubsystemStatus.unknown,
      Subsystem.frontLeftMotor: !systemStale ? systemInfo!.frontLeftMotor : SubsystemStatus.unknown,
      Subsystem.rearLeftMotor: !systemStale ? systemInfo!.rearLeftMotor : SubsystemStatus.unknown,
      Subsystem.frontRightMotor: !systemStale ? systemInfo!.frontRightMotor : SubsystemStatus.unknown,
      Subsystem.rearRightMotor: !systemStale ? systemInfo!.rearRightMotor : SubsystemStatus.unknown,
      Subsystem.uhfRadio: !computeStale ? computeCommInfo!.uhfRadio : SubsystemStatus.unknown,
      Subsystem.lBandRadio: !computeStale ? computeCommInfo!.lBandRadio : SubsystemStatus.unknown,
      Subsystem.compute: !computeStale ? computeCommInfo!.compute : SubsystemStatus.unknown,
    };
  }

  /// Helper to get the most recent update time across all entities
  DateTime? get lastUpdateTime {
    if (systemInfoLastUpdate == null) return computeInfoLastUpdate;
    if (computeInfoLastUpdate == null) return systemInfoLastUpdate;
    return systemInfoLastUpdate!.isAfter(computeInfoLastUpdate!) 
        ? systemInfoLastUpdate 
        : computeInfoLastUpdate;
  }
}
