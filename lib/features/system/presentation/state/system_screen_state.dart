import '../../domain/entities/system_info_entity.dart';
import '../../domain/entities/compute_comm_info_entity.dart';
import '../../enums/subsystem_status_enum.dart';

class SystemScreenState {
  final SystemInfoEntity? systemInfo;
  final ComputeCommInfoEntity? computeCommInfo;

  const SystemScreenState({
    this.systemInfo,
    this.computeCommInfo,
  });

  SystemScreenState copyWith({
    SystemInfoEntity? systemInfo,
    ComputeCommInfoEntity? computeCommInfo,
  }) {
    return SystemScreenState(
      systemInfo: systemInfo ?? this.systemInfo,
      computeCommInfo: computeCommInfo ?? this.computeCommInfo,
    );
  }

  Map<String, SubsystemStatus> get allHealthStatus {
    final Map<String, SubsystemStatus> statusMap = {};
    
    // Data from 0x203
    if (systemInfo != null) {
      statusMap.addAll(systemInfo!.subsystemHealthMap);
    }

    // Data from 0x20C
    if (computeCommInfo != null) {
      statusMap['UHF Radio'] = computeCommInfo!.uhfRadio;
      statusMap['L Band Radio'] = computeCommInfo!.lBandRadio;
      statusMap['Compute Unit'] = computeCommInfo!.compute;
    }

    return statusMap;
  }
}
