import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/checksum_status_entity.dart';

class ChecksumStatusMapper {

  Object? _decodeJson(Uint8List data) {
    final String text;
    try {
      text = utf8.decode(data);
    } on FormatException {
      return null;
    }

    // Sanitize unescaped raw newlines/carriage returns embedded inside
    // JSON strings, which would otherwise be invalid JSON.
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

  List<ChecksumStatusEntity> fromBytes(
    Uint8List data,
  ) {
    final decoded = _decodeJson(data);

    if (decoded is List) {
      return fromArray(decoded);
    }
    if (decoded is Map<String, dynamic>) {
      return fromEnvelope(decoded);
    }
    return const [];
  }

  List<ChecksumStatusEntity> fromArray(
    List<dynamic> array) {
    final entities = <ChecksumStatusEntity>[];

    for (final element in array) {
      if (element is! Map) continue;

      final appJson = element.map((k, v) => MapEntry(k.toString(), v));
      final appName = appJson['app_name'];
      if (appName is! String) continue;

      final entity = _mapSingleApp(
        appName: appName,
        appJson: appJson,
      );
      if (entity != null) entities.add(entity);
    }

    return entities;
  }


  List<ChecksumStatusEntity> fromEnvelope(
    Map<String, dynamic> envelope) {
    final entities = <ChecksumStatusEntity>[];

    // Shape 1: the envelope's own top-level fields describe one app.
    final directAppName = envelope['app_name'];
    if (directAppName is String && directAppName.isNotEmpty) {
      final entity = _mapSingleApp(
        appName: directAppName,
        appJson: envelope,
      );
      if (entity != null) entities.add(entity);
    }

    // Shape 2 (+ nested shape 3): any other top-level key whose value
    // is a Map or a List describes one or more additional apps.
    for (final entry in envelope.entries) {
      final value = entry.value;

      if (value is Map) {
        final appJson = value.map((k, v) => MapEntry(k.toString(), v));
        final nestedAppName = appJson['app_name'];
        final appName = (nestedAppName is String && nestedAppName.isNotEmpty)
            ? nestedAppName
            : entry.key; // fall back to the envelope key as the app name

        final entity = _mapSingleApp(
          appName: appName,
          appJson: appJson,
        );
        if (entity != null) entities.add(entity);
      } else if (value is List) {
        entities.addAll(fromArray(value));
      }
    }

    return entities;
  }

  /// Capitalizes the first letter of [input] and makes the rest lowercase.
  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  ChecksumStatusEntity? _mapSingleApp({
    required String appName,
    required Map<String, dynamic> appJson,
  }) {
    if (appName.isEmpty) return null;

    final formattedAppName = _capitalize(appName);
    final version = appJson['version'];
    final checksum = appJson['checksum'];

    return ChecksumStatusEntity(
      appName: formattedAppName,
      version: version is String ? version : 'unknown',
      checksum: checksum is String ? checksum : 'unknown',
    );
  }
}