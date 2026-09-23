class ChecksumStatusEntity {
  final String appName;
  final String version;
  final String checksum;

  const ChecksumStatusEntity({
    required this.appName,
    required this.version,
    required this.checksum,
  });

  bool get hasUnknownChecksum => checksum.toLowerCase() == 'unknown';

  String get sourceKey => appName;

  @override
  String toString() =>
      'ChecksumStatusEntity(appName: $appName, version: $version, '
      'checksum: $checksum)';
}