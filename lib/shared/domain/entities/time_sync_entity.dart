class TimeSyncEntity {
  const TimeSyncEntity({
    required this.linkId,
    required this.timeOffsetUs,
    required this.roundTripUs,
    required this.measuredAt,
  });

  final String linkId;
  final int timeOffsetUs; // OBD clock offset from vehicle in microseconds
  final int roundTripUs; // round-trip latency in microseconds
  final DateTime measuredAt;

  /// UGV-corrected local time
  DateTime get correctedNow =>
      DateTime.now().add(Duration(microseconds: timeOffsetUs));

  int get roundTripMs => roundTripUs ~/ 1000;

  bool get isStale => DateTime.now().difference(measuredAt).inSeconds > 5;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TimeSyncEntity &&
              other.linkId == linkId &&
              other.timeOffsetUs == timeOffsetUs;

  @override
  int get hashCode => Object.hash(linkId, timeOffsetUs);
}