
import 'package:scout_obd/shared/domain/entities/time_sync_entity.dart';

/// Maps raw MAVLink TIMESYNC fields → domain entity.
/// MAVLink TIMESYNC field units: MICROSECONDS (not nanoseconds).
/// DateTime.microsecondsSinceEpoch [Jan 01 1970] is also microseconds.
/// All math here stays in microseconds — no unit conversion needed.

// Domain models can have fields which aren't in models.
// toEntity method should accept the extra fields and return the domain entity.
// Repositories are responsible for calling the toEntity method to hold them.

class TimeSyncModel {
  const TimeSyncModel({
    required this.tc1,
    required this.ts1,
    required this.targetSystem,
    required this.targetComponent,
  });

  final int tc1;
  final int ts1;
  final int targetSystem;
  final int targetComponent;

  TimeSyncEntity toEntity(String linkId) {
    final nowUs = DateTime.now().microsecondsSinceEpoch;
    final rttUs = nowUs - ts1;

    final offsetUs = tc1 - (ts1 + rttUs ~/ 2);

    return TimeSyncEntity(
      linkId: linkId,
      timeOffsetUs: offsetUs,
      roundTripUs: rttUs,
      measuredAt: DateTime.now(),
    );
  }

}
