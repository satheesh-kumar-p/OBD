import 'dart:io';

class ChecksumSelfInfoService {
  static const String _compileTimeAppName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'OBD',
  );

  static const String _compileTimeVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '',
  );

  String _stripHashPrefix(String checksum) {
    const prefix = 'sha256:';
    return checksum.toLowerCase().startsWith(prefix)
        ? checksum.substring(prefix.length)
        : checksum;
  }

  Future<String?> _getRepoDigest() async {
    try {
      final imageResult = await Process.run('docker', [
        'inspect', 'obd', '--format', '{{.Config.Image}}',
      ], runInShell: false);      // run the program directly without opening a terminal window behind the scenes
      if (imageResult.exitCode != 0) return null;

      final image = imageResult.stdout.toString().trim();
      if (image.isEmpty) return null;

      final digestResult = await Process.run('docker', [
        'image', 'inspect', image, '--format', '{{index .RepoDigests 0}}',
      ], runInShell: false);
      if (digestResult.exitCode != 0) return null;

      final repoDigest = digestResult.stdout.toString().trim();
      return repoDigest.isEmpty ? null : repoDigest;
    } catch (_) {
      return null;
    }
  }

  Future<({String name, String version, String checksum})> fetchBuildInfo() async {
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
    return (name: name, version: version, checksum: checksum);
  }
}