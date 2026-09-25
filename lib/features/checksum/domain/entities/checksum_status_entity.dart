/// Decoded representation of ONE app's checksum/version status.
class ChecksumStatusEntity {
  final String appName;
  final String version;
  final String checksum;

  const ChecksumStatusEntity({
    required this.appName,
    required this.version,
    required this.checksum,
  });

  /// True when the source reported "unknown" for checksum — used for
  /// UI warning/dimming.
  bool get hasUnknownChecksum => checksum.toLowerCase() == 'unknown';

  /// Identity key for "latest status per app" maps.
  String get sourceKey => appName;

  @override
  String toString() =>
      'ChecksumStatusEntity(appName: $appName, version: $version, checksum: $checksum)';
}