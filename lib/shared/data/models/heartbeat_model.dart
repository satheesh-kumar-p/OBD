import 'package:scout_obd/shared/domain/entities/heartbeat_entity.dart';

class HeartbeatModel {
  const HeartbeatModel({
    required this.type,
    required this.autopilot,
    required this.baseMode,
    required this.customMode,

    /// Mode info comes in this field
    required this.systemStatus,
    required this.mavlinkVersion,
  });

  final int type;
  final int autopilot;
  final int baseMode;
  final int customMode;
  final int systemStatus;
  final int mavlinkVersion;

  HeartbeatEntity toEntity(String linkId, int systemId) =>
      HeartbeatEntity(
        linkId: linkId,
        systemId: systemId,
        type: type,
        autopilot: autopilot,
        baseMode: baseMode,
        customMode: customMode,
        systemStatus: systemStatus,
        receivedAt: DateTime.now(),
      );

}
