class SystemTimeEntity {

  const SystemTimeEntity({
    required this.linkId,
    required this.upTimeMs,
    required this.unixTimeUs,
    required this.receivedAt,
  });

  final String linkId;
  final int upTimeMs;
  final DateTime unixTimeUs;
  final DateTime receivedAt;
}