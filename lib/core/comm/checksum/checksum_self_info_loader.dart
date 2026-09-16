import 'dart:io';

import 'checksum_status_entity.dart';

/// Loads this application's own build identity.
///
/// The application name and version come from the existing
/// compile-time Dart defines.
///
/// The checksum is obtained at runtime from Docker by:
///
/// 1. Finding which image the `obd` container is running.
/// 2. Getting that image's RepoDigest.
///
/// Docker socket must be mounted into the container:
///
///   /var/run/docker.sock:/var/run/docker.sock:ro
///
/// and the Docker CLI must be available inside the container.
abstract final class ChecksumSelfInfoLoader {
  // Compile-time APP_NAME passed via:
  //
  // --dart-define=APP_NAME=...
  static const String _compileTimeAppName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'OBD',
  );

  // Compile-time APP_VERSION passed via:
  //
  // --dart-define=APP_VERSION=...
  static const String _compileTimeVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '',
  );

  static String get appName => _compileTimeAppName;

  static ChecksumStatusEntity? _cached;
  static bool _attempted = false;

  /// Removes the `sha256:` prefix because the UI currently expects
  /// only the hexadecimal checksum.
  static String _stripHashPrefix(String checksum) {
    const prefix = 'sha256:';

    if (checksum.toLowerCase().startsWith(prefix)) {
      return checksum.substring(prefix.length);
    }

    return checksum;
  }

  /// Gets the RepoDigest of the Docker image running the OBD app.
  ///
  /// Example:
  ///
  ///   registry.example.com/scout-obd:f7-v1.0-alpha-1
  ///
  /// becomes:
  ///
  ///   registry.example.com/scout-obd@sha256:abcdef123456...
  ///
  /// The OBD container is explicitly named `obd` in docker-compose.yml,
  /// so this does not accidentally inspect another application container.
  static String? _getRepoDigest() {
    try {
      // ------------------------------------------------------------
      // Step 1: Find the image used by the `obd` container.
      // ------------------------------------------------------------
      final imageResult = Process.runSync(
        'docker',
        [
          'inspect',
          'obd',
          '--format',
          '{{.Config.Image}}',
        ],
        runInShell: false,
      );

      if (imageResult.exitCode != 0) {
        return null;
      }

      final image = imageResult.stdout.toString().trim();

      if (image.isEmpty) {
        return null;
      }

      // ------------------------------------------------------------
      // Step 2: Get the RepoDigest of that image.
      // ------------------------------------------------------------
      final digestResult = Process.runSync(
        'docker',
        [
          'image',
          'inspect',
          image,
          '--format',
          '{{index .RepoDigests 0}}',
        ],
        runInShell: false,
      );

      if (digestResult.exitCode != 0) {
        return null;
      }

      final repoDigest = digestResult.stdout.toString().trim();

      if (repoDigest.isEmpty) {
        return null;
      }

      return repoDigest;
    } catch (_) {
      return null;
    }
  }

  /// Loads this application's own checksum status.
  ///
  /// The returned entity has the same structure as the entities
  /// created by ChecksumStatusMapper.
  static ChecksumStatusEntity? load() {
    // Prevent Docker from being queried more than once.
    if (_attempted) {
      return _cached;
    }

    _attempted = true;

    // --------------------------------------------------------------
    // App name
    // --------------------------------------------------------------
    final name = _compileTimeAppName;

    // --------------------------------------------------------------
    // Version
    //
    // This remains exactly the same compile-time version mechanism.
    // --------------------------------------------------------------
    final version = _compileTimeVersion.isNotEmpty
        ? _compileTimeVersion
        : '/';

    // --------------------------------------------------------------
    // Checksum
    //
    // Get the RepoDigest directly from Docker.
    // --------------------------------------------------------------
    final repoDigest = _getRepoDigest();

    if (repoDigest == null || repoDigest.isEmpty) {
      return null;
    }

    // Example:
    //
    // registry.example.com/scout-obd@sha256:abcdef123456...
    //
    // Extract:
    //
    // sha256:abcdef123456...
    final rawChecksum = repoDigest.contains('@')
        ? repoDigest.substring(repoDigest.indexOf('@') + 1)
        : repoDigest;

    final checksum = _stripHashPrefix(rawChecksum);

    // --------------------------------------------------------------
    // Build the SAME entity used by UDP checksum information.
    // --------------------------------------------------------------
    _cached = ChecksumStatusEntity(
      appName: name,
      version: version,
      checksum: checksum,
      receivedAt: DateTime.now(),
    );

    return _cached;
  }
}