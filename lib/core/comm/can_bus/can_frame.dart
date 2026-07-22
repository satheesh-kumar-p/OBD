import 'dart:typed_data';

import '../../enums/can_enums.dart';

/// Represents a CAN frame matching the Waveshare Serial-to-CAN Variable Length Protocol.
class CanFrame {
  /// 11-bit or 29-bit message identifier.
  final int id;

  /// Whether this is a standard or extended frame.
  final CanIdType idType;

  /// Whether this is a data frame or a remote frame.
  final CanFrameFormat format;

  /// Payload bytes (0 to 8 bytes).
  final Uint8List data;

  CanFrame({
    required this.id,
    required this.idType,
    this.format = CanFrameFormat.data,
    required this.data,
  }) {
    if (data.length > 8) {
      throw ArgumentError('CAN data payload cannot exceed 8 bytes');
    }
  }

  /// Data Length Code (DLC).
  int get dlc => data.length;

  @override
  String toString() {
    final hexId = '0x${id.toRadixString(16).padLeft(idType == CanIdType.extended ? 8 : 3, '0')}';
    final hexData = data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    return 'CanFrame(id: $hexId, type: ${idType.name}, format: ${format.name}, dlc: $dlc, data: [$hexData])';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanFrame &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          idType == other.idType &&
          format == other.format &&
          _listEquals(data, other.data);

  @override
  int get hashCode => Object.hash(id, idType, format, Object.hashAll(data));

  static bool _listEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
