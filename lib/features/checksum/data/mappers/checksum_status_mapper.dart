import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/checksum_status_entity.dart';

/// Decoding logic lives here: raw UDP bytes -> ChecksumStatusEntity
/// objects. Handles three payload shapes:
/// 1. Flat single-app object.
/// 2. Combined multi-app envelope (object keyed by app name).
/// 3. Array of app-status objects.
/// A payload may combine shape 1 with 2 or 3 in the same envelope —
/// all applicable shapes are checked, never just the first match.
class ChecksumStatusMapper {
  Object? _decodeJson(Uint8List data) {
    final String text;
    try {
      text = utf8.decode(data);
    } on FormatException {
      return null;
    }

    final sanitized = text
        .replaceAll('\r\n', r'\n')
        .replaceAll('\r', r'\n')
        .replaceAll('\n', r'\n');

    try {
      return jsonDecode(sanitized);
    } on FormatException {
      return null;
    }
  }

  List<ChecksumStatusEntity> fromBytes(Uint8List data) {
    final decoded = _decodeJson(data);

    if (decoded is List) return fromArray(decoded);
    if (decoded is Map<String, dynamic>) return fromEnvelope(decoded);
    return const [];
  }

  List<ChecksumStatusEntity> fromArray(List<dynamic> array) {
    final entities = <ChecksumStatusEntity>[];

    for (final element in array) {
      if (element is! Map) continue;

      final appJson = element.map((k, v) => MapEntry(k.toString(), v));
      final appName = appJson['app_name'];
      if (appName is! String) continue;

      final entity = _mapSingleApp(appName: appName, appJson: appJson);
      if (entity != null) entities.add(entity);
    }

    return entities;
  }

  List<ChecksumStatusEntity> fromEnvelope(Map<String, dynamic> envelope) {
    final entities = <ChecksumStatusEntity>[];

    final directAppName = envelope['app_name'];
    if (directAppName is String && directAppName.isNotEmpty) {
      final entity = _mapSingleApp(appName: directAppName, appJson: envelope);
      if (entity != null) entities.add(entity);
    }

    for (final entry in envelope.entries) {
      final value = entry.value;

      if (value is Map) {
        final appJson = value.map((k, v) => MapEntry(k.toString(), v));
        final nestedAppName = appJson['app_name'];
        final appName = (nestedAppName is String && nestedAppName.isNotEmpty)
            ? nestedAppName
            : entry.key;

        final entity = _mapSingleApp(appName: appName, appJson: appJson);
        if (entity != null) entities.add(entity);
      } else if (value is List) {
        entities.addAll(fromArray(value));
      }
    }

    return entities;
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  ChecksumStatusEntity? _mapSingleApp({
    required String appName,
    required Map<String, dynamic> appJson,
  }) {
    if (appName.isEmpty) return null;

    final version = appJson['version'];
    final checksum = appJson['checksum'];

    return ChecksumStatusEntity(
      appName: _capitalize(appName),
      version: version is String ? version : 'unknown',
      checksum: checksum is String ? checksum : 'unknown',
    );
  }
}