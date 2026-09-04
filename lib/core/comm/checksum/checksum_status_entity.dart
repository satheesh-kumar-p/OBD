/// Decoded representation of ONE app's status, extracted from the
/// checksum UDP stream. The real payload only ever carries these three
/// fields, either flat:
/// ```json
/// {"app_name":"telematics_server","version":"f7-local-20260903","checksum":"d23f..."}
/// ```
/// or nested per-app inside a combined envelope:
/// ```json
/// {"telemetry":{"version":"...","checksum":"..."},"atlas":{...},"vision":{...}}
/// ```
/// (app name taken from the envelope key in that case).
///
/// [ChecksumStatusMapper] fans a packet out into one entity per app.
/// The stream is a heartbeat-style feed: the UI tracks the latest
/// entity per `appName`, not a history of every packet.
class ChecksumStatusEntity {
  final String appName;
  final String version;
  final String checksum;

  /// Local receive time, captured when this app decoded the packet (or,
  /// for this app's own self-info row, when that row was built).
  final DateTime receivedAt;

  const ChecksumStatusEntity({
    required this.appName,
    required this.version,
    required this.checksum,
    required this.receivedAt,
  });

  /// True when the source reported "unknown" for checksum (seen from
  /// ATLAS in early/idle states) — useful for UI dimming/warning color.
  bool get hasUnknownChecksum => checksum.toLowerCase() == 'unknown';

  /// Unique key for this app's slot in a "latest status per app" map.
  /// App name alone is the identity now — there's no source address to
  /// disambiguate by, since the real payload never carries one.
  String get sourceKey => appName;

  ChecksumStatusEntity copyWith({
    String? appName,
    String? version,
    String? checksum,
    DateTime? receivedAt,
  }) {
    return ChecksumStatusEntity(
      appName: appName ?? this.appName,
      version: version ?? this.version,
      checksum: checksum ?? this.checksum,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  String toString() =>
      'ChecksumStatusEntity(appName: $appName, version: $version, '
      'checksum: $checksum, receivedAt: $receivedAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecksumStatusEntity &&
          runtimeType == other.runtimeType &&
          appName == other.appName &&
          version == other.version &&
          checksum == other.checksum;

  @override
  int get hashCode => Object.hash(appName, version, checksum);
}