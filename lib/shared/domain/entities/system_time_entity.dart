class SystemTimeEntity {

  const SystemTimeEntity({
    required this.linkId,
    required this.upTimeSeconds,
    required this.measuredAt,
  });

  final String linkId;
  final int upTimeSeconds;
  final DateTime measuredAt;

  /// Estimated current uptime in seconds (extrapolated)
  int get currentUpTimeSeconds {
    final elapsed = DateTime.now().difference(measuredAt).inSeconds;
    return upTimeSeconds + elapsed;
  }
}
