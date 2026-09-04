import 'dart:io';

import 'checksum_status_entity.dart';

/// This application's own build identity, for display as a row on the
/// checksum screen alongside packets received over UDP from
/// telematics_server / ATLAS / VISION.
///
/// Reads identity directly from runtime container environment variables
/// (`APP_VERSION` and `APP_CHECKSUM`) passed via `docker run -e`.
abstract final class ChecksumSelfInfoLoader {
  // Compile-time fallbacks (via --dart-define if supplied)
  static const String _compileTimeVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '',
  );
  static const String _compileTimeChecksum = String.fromEnvironment(
    'APP_CHECKSUM',
    defaultValue: '',
  );

  static const String appName = 'SCOUT-OBD';
  static const String appVersionEnvVar = 'APP_VERSION';
  static const String imageChecksumEnvVar = 'APP_CHECKSUM';

  static ChecksumStatusEntity? _cached;
  static bool _attempted = false;

  /// Strips a leading "sha256:" prefix, if present, so the UI shows
  /// just the hex digest — matching how remote apps' checksums are
  /// displayed (they never carry this prefix). Case-insensitive, since
  /// Docker itself always lowercases it but a manually-set env var
  /// might not.
  static String _stripHashPrefix(String checksum) {
    const prefix = 'sha256:';
    if (checksum.toLowerCase().startsWith(prefix)) {
      return checksum.substring(prefix.length);
    }
    return checksum;
  }

  static ChecksumStatusEntity? load() {
    if (_attempted) return _cached;
    _attempted = true;

    // 1. Resolve Version: Container ENV -> Compile-Time Arg -> Default 'dev'
    final envVersion = Platform.environment[appVersionEnvVar];
    final version = (envVersion != null && envVersion.isNotEmpty)
        ? envVersion
        : (_compileTimeVersion.isNotEmpty ? _compileTimeVersion : '/');

    // 2. Resolve Checksum (RepoDigest): Container ENV -> Compile-Time Arg -> 'unknown'
    final envChecksum = Platform.environment[imageChecksumEnvVar];
    final rawChecksum = (envChecksum != null && envChecksum.isNotEmpty)
        ? envChecksum
        : (_compileTimeChecksum.isNotEmpty ? _compileTimeChecksum : '');

    if (rawChecksum.isEmpty) return null;

    final checksum = _stripHashPrefix(rawChecksum);

    _cached = ChecksumStatusEntity(
      appName: appName,
      version: version,
      checksum: checksum,
      receivedAt: DateTime.now(),
    );
    return _cached;
  }
}