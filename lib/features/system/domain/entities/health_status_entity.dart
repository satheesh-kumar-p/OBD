import 'package:scout_obd/features/system/enums/subsystem_status_enum.dart';

class HealthStatusEntity {
  final Map<String, SubsystemStatus> subsystemHealthMap;

  const HealthStatusEntity(this.subsystemHealthMap);

  SubsystemStatus subsystem(String key) {
    final status = subsystemHealthMap[key];
    if (status == null) throw ArgumentError('Unknown subsystem: $key');
    return status;
  }

}