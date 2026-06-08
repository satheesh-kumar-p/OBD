import 'dart:typed_data';

import '../../utils/bit_util.dart';

/// Defines how to extract and transform a single value from a CAN frame.
class CanField<T> {
  final String name;
  final int startBit;
  final int endBit;
  final T Function(int rawValue)? transformer;

  const CanField({
    required this.name,
    required this.startBit,
    required this.endBit,
    this.transformer,
  });

  /// Extracts the value from the raw payload.
  T extract(Uint8List data) {
    final raw = BitUtil.getBitsByRange(data, startBit, endBit);
    if (transformer != null) {
      return transformer!(raw);
    }
    return raw as T;
  }
}