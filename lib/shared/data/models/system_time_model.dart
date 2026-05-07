import 'package:scout_obd/shared/domain/entities/system_time_entity.dart';

/// ICD model for MAVLink SYSTEM_TIME (message id 2).
/// Raw field mapping only — no business logic.
class SystemTimeModel {
  const SystemTimeModel({
    required this.timeUnixUsec, // Unix time in microseconds
    required this.timeBootMs, // Vehicle boot time in milliseconds
  });

  final int timeUnixUsec;
  final int timeBootMs;

  SystemTimeEntity toEntity(String linkId) {
    final nowUs = DateTime.now().microsecondsSinceEpoch;
    final offsetUs = timeUnixUsec - nowUs;

    return SystemTimeEntity(
      linkId: linkId,
      upTimeSeconds: timeBootMs ~/ 1000,
      measuredAt: DateTime.now(),
    );
  }
}
