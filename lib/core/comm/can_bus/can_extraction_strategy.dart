import 'dart:typed_data';

import 'can_field.dart';

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