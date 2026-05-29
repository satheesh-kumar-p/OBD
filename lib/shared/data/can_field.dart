import 'dart:typed_data';
import '../../core/utils/bit_util.dart';

/// Defines how to extract and transform a single value from a CAN frame.
class CanField<T> {
  final String name;
  final int startBit;
  final int bitLength;
  final T Function(int rawValue)? transformer;

  const CanField({
    required this.name,
    required this.startBit,
    required this.bitLength,
    this.transformer,
  });

  /// Extracts the value from the raw payload.
  T extract(Uint8List data) {
    final raw = BitUtil.getBitsByLength(data, startBit, bitLength);
    if (transformer != null) {
      return transformer!(raw);
    }
    return raw as T;
  }
}

/// A Strategy for a specific CAN Message ID.
abstract class CanExtractionStrategy<T> {
  /// All fields in this CAN message with their bit positions
  List<CanField<dynamic>> get fields;

  /// The CAN message ID this strategy handles
  int get messageId;

  /// Parse raw CAN payload into a TYPE-SAFE domain model.
  /// This is the main method you'll call when receiving CAN data.
  T parse(Uint8List data) {
    // Extract all fields into a map
    final Map<String, dynamic> rawValues = {};
    for (final field in fields) {
      rawValues[field.name] = field.extract(data);
    }

    // Build and return the domain model
    return build(rawValues);
  }

  /// Build the domain model from extracted field values.
  /// Implement this in your concrete strategy to create your entity.
  T build(Map<String, dynamic> parsedValues);
}
