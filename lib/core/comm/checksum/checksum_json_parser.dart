// import 'dart:convert';
// import 'dart:typed_data';

// /// Decodes raw checksum-stream UDP payload bytes into JSON data.
// ///
// /// This is the "parser" layer for the checksum stream, matching the role
// /// `CanFrameParser` plays for the CAN transport:
// ///
// /// - [CommManager]'s checksum transport knows nothing about payload
// ///   format; it only produces raw bytes ([ChecksumPacket]).
// /// - [ChecksumJsonParser] (this file) knows the payload is UTF-8 JSON
// ///   text and turns bytes into a generic `Map<String, dynamic>`. It
// ///   knows nothing about "app status" or any other domain concept.
// /// - [ChecksumStatusMapper] knows nothing about bytes or UTF-8; it only
// ///   turns an already-decoded `Map<String, dynamic>` envelope into typed
// ///   domain entities (one per app).
// ///
// /// Kept deliberately dumb and defensive: malformed input returns `null`
// /// rather than throwing, so one bad datagram never disrupts the stream.
// abstract final class ChecksumJsonParser {
//   /// Decodes [data] as UTF-8 text. Returns `null` if the bytes are not
//   /// valid UTF-8.
//   static String? decodeText(Uint8List data) {
//     try {
//       return utf8.decode(data);
//     } on FormatException {
//       return null;
//     }
//   }

//   /// Sanitizes unescaped raw newlines/carriage returns embedded inside JSON strings.
//   static String _sanitizeJsonText(String rawText) {
//     return rawText
//         .replaceAll('\r\n', r'\n')
//         .replaceAll('\r', r'\n')
//         .replaceAll('\n', r'\n');
//   }

//   /// Decodes [data] as UTF-8 JSON and returns the parsed object as a
//   /// `Map<String, dynamic>`. Returns `null` if the bytes are not valid
//   /// UTF-8, not valid JSON, or the JSON root is not an object.
//   ///
//   /// The root object is the multi-app envelope, e.g.:
//   /// ```json
//   /// { "telemetry": {...}, "atlas": {...}, "vision": {...} }
//   /// ```
//   static Map<String, dynamic>? decodeJson(Uint8List data) {
//     final text = decodeText(data);
//     if (text == null) return null;

//     final sanitizedText = _sanitizeJsonText(text);

//     late final Object? parsed;
//     try {
//       parsed = jsonDecode(sanitizedText);
//     } on FormatException {
//       return null;
//     }

//     if (parsed is Map<String, dynamic>) {
//       return parsed;
//     }

//     return null;
//   }
// }