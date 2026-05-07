/// Sensor‑bus / BMS error flags, matching ICD.
/// Bitmask field: sensorBusErrors
/// 0x01 → BAT_UNDER_VOLTAGE
/// 0x02 → BAT_OVER_CURRENT
/// 0x04 → BAT_OVER_VOLTAGE
/// 0x08 → BAT_OVER_TEMP
enum UgvSensorError {
  underVoltage(1),
  overCurrent(2),
  overVoltage(4),
  overTemp(8);

  const UgvSensorError(this.bit);
  final int bit;

  /// Converts a raw ICD bitmask into a set of meaningful sensor/BMS errors.
  static Set<UgvSensorError> fromBitmask(int bitmask) {
    final result = <UgvSensorError>{};
    for (final err in values) {
      if ((bitmask & err.bit) != 0) {
        result.add(err);
      }
    }
    return result;
  }
}

/// Domain wrapper for the sensor‑bus (BMS) error bitmask.
///
/// Example:
///   final sensorBusErrors = UgvSensorErrorSet.fromBitmask(dto.sensorBusErrors);
class UgvSensorErrorSet {
  /// The set of sensor/BMS errors represented by this mask.
  final Set<UgvSensorError> errors;

  /// Create a new sensor‑error set. Prefer `UgvSensorErrorSet.fromBitmask`
  /// when converting from a raw ICD bitmask.
  const UgvSensorErrorSet(this.errors);

  /// Create a `UgvSensorErrorSet` from a raw sensor‑bus error bitmask.
  ///
  /// Example:
  ///   final sensorBus = UgvSensorErrorSet.fromBitmask(sensorBusErrors);
  static UgvSensorErrorSet fromBitmask(int bitmask) {
    return UgvSensorErrorSet(UgvSensorError.fromBitmask(bitmask));
  }

  /// Returns `true` if BAT_UNDER_VOLTAGE (bit 0) is set in the bitmask.
  bool isUnderVoltage() => errors.contains(UgvSensorError.underVoltage);

  /// Returns `true` if BAT_OVER_VOLTAGE (bit 2) is set in the bitmask.
  bool isOverVoltage() => errors.contains(UgvSensorError.overVoltage);

  /// Returns `true` if BAT_OVER_CURRENT (bit 1) is set in the bitmask.
  bool isOverCurrent() => errors.contains(UgvSensorError.overCurrent);

  /// Returns `true` if BAT_OVER_TEMP (bit 3) is set in the bitmask.
  bool isOverTemp() => errors.contains(UgvSensorError.overTemp);

  /// Returns `true` if any sensor/BMS error flag is set.
  bool hasAnyFault() => errors.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UgvSensorErrorSet &&
              errors.length == other.errors.length &&
              errors.toSet().containsAll(other.errors);

  @override
  int get hashCode => errors.toSet().hashCode;

  @override
  String toString() => 'UgvSensorErrorSet($errors)';
}