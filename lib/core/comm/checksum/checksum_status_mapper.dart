import 'dart:convert';
import 'dart:typed_data';

import 'checksum_status_entity.dart';

/// Converts raw checksum-stream UDP bytes into [ChecksumStatusEntity]
/// objects.
///
/// Two real decode steps happen before any field can be read:
///   1. bytes -> UTF-8 text        (the wire format is always JSON text)
///   2. text  -> Map<String, dynamic>   (jsonDecode)
/// Only after both does `json['app_name']` etc. become possible — this
/// is unavoidable for any JSON-over-UDP payload, not extra overhead.
///
/// Handles two payload shapes (see [fromEnvelope]): a flat single-app
/// packet (`{"app_name":"telematics_server","version":"...",
/// "checksum":"..."}`) and a combined multi-app envelope
/// (`{"telemetry":{...},"atlas":{...},"vision":{...}}`). Either way,
/// only `app_name`/`version`/`checksum` are ever read.
abstract final class ChecksumStatusMapper {
  /// Step 1+2: decodes raw bytes as UTF-8 JSON. Returns `null` on any
  /// failure (bad UTF-8, invalid JSON, non-object root) — never throws,
  /// so one malformed datagram can't disrupt the stream.
  static Map<String, dynamic>? _decodeJson(Uint8List data) {
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

    late final Object? parsed;
    try {
      parsed = jsonDecode(sanitized);
    } on FormatException {
      return null;
    }

    return parsed is Map<String, dynamic> ? parsed : null;
  }

  /// Entry point: decode + map in one step. Returns an empty list if
  /// decoding fails or the envelope has no valid app entries.
  static List<ChecksumStatusEntity> fromBytes(
    Uint8List data, {
    required DateTime receivedAt,
  }) {
    final json = _decodeJson(data);
    if (json == null) return const [];
    return fromEnvelope(json, receivedAt: receivedAt);
  }

  /// Maps an already-decoded envelope into a list of typed entities.
  ///
  /// Handles TWO observed shapes:
  /// 1. Flat single-app packet — the entire envelope IS one app's
  ///    status. Detected by a top-level `app_name` string.
  /// 2. Combined multi-app envelope — each top-level key is an app
  ///    name, its value that app's own status object. Used as the
  ///    fallback when no top-level `app_name` is present. Keys whose
  ///    value isn't an object are skipped rather than treated as an
  ///    error, so one malformed entry doesn't drop the rest.
  static List<ChecksumStatusEntity> fromEnvelope(
    Map<String, dynamic> envelope, {
    required DateTime receivedAt,
  }) {
    final directAppName = envelope['app_name'];
    if (directAppName is String && directAppName.isNotEmpty) {
      final entity = _mapSingleApp(
        appName: directAppName,
        appJson: envelope,
        receivedAt: receivedAt,
      );
      return entity == null ? const [] : [entity];
    }

    final entities = <ChecksumStatusEntity>[];

    for (final entry in envelope.entries) {
      final value = entry.value;
      if (value is! Map) continue;

      final appJson = value.map((k, v) => MapEntry(k.toString(), v));

      final nestedAppName = appJson['app_name'];
      final appName = (nestedAppName is String && nestedAppName.isNotEmpty)
          ? nestedAppName
          : entry.key;

      final entity = _mapSingleApp(
        appName: appName,
        appJson: appJson,
        receivedAt: receivedAt,
      );
      if (entity != null) entities.add(entity);
    }

    return entities;
  }

  /// Capitalizes the first letter of [input] and makes the rest lowercase.
  static String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  /// Maps one app's JSON object into an entity. Only `version` and
  /// `checksum` are read — the real payload never carries anything
  /// else.
  static ChecksumStatusEntity? _mapSingleApp({
    required String appName,
    required Map<String, dynamic> appJson,
    required DateTime receivedAt,
  }) {
    if (appName.isEmpty) return null;

    final formattedAppName = _capitalize(appName);
    final version = appJson['version'];
    final checksum = appJson['checksum'];

    return ChecksumStatusEntity(
      appName: formattedAppName,
      version: version is String ? version : 'unknown',
      checksum: checksum is String ? checksum : 'unknown',
      receivedAt: receivedAt,
    );
  }
}