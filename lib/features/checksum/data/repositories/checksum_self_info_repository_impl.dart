import 'dart:io';

import '../../domain/entities/checksum_status_entity.dart';
import '../../domain/repositories/i_checksum_self_info_repository.dart';

/// Data layer: fetches this app's own build identity — compile-time
/// dart-defines plus a Docker image digest lookup — and caches the
/// result so the Docker CLI is only ever queried once.
class ChecksumSelfInfoRepositoryImpl implements IChecksumSelfInfoRepository {
  static const String _compileTimeAppName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'OBD',
  );

  static const String _compileTimeVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '',
  );

  ChecksumStatusEntity? _cached;
  bool _attempted = false;

  String _stripHashPrefix(String checksum) {
    const prefix = 'sha256:';
    return checksum.toLowerCase().startsWith(prefix)
        ? checksum.substring(prefix.length)
        : checksum;
  }

Future<String?> _runDocker(List<String> args) async {
  try {
    final result = await Process.run('docker', args, runInShell: false);
    if (result.exitCode != 0) return null;
    final output = result.stdout.toString().trim();
    return output.isEmpty ? null : output;
  } catch (_) {
    return null;
  }
}

Future<String?> _getRepoDigest() async {
  final image = await _runDocker(['inspect', 'obd', '--format', '{{.Config.Image}}']);
  if (image == null) return null;
  return _runDocker(['image', 'inspect', image, '--format', '{{index .RepoDigests 0}}']);
}
  @override
  Future<ChecksumStatusEntity?> getSelfInfo() async {
    if (_attempted) return _cached;
    _attempted = true;

    final name = _compileTimeAppName;
    final version = _compileTimeVersion.isNotEmpty ? _compileTimeVersion : '/';
    final repoDigest = await _getRepoDigest();

    String checksum = 'unknown';
    if (repoDigest != null && repoDigest.isNotEmpty) {
      final raw = repoDigest.contains('@')
          ? repoDigest.substring(repoDigest.indexOf('@') + 1)
          : repoDigest;
      checksum = _stripHashPrefix(raw);
    }

    _cached = ChecksumStatusEntity(appName: name, version: version, checksum: checksum);
    return _cached;
  }
}