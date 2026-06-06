enum UgvMotorError {
  overload(1),
  overTemp(2),
  overSpeed(4),
  stalled(8),
  phaseLoss(16),
  hallFault(32),
  encoderFault(64),
  brakeFault(128);

  const UgvMotorError(this.bit);
  final int bit;

  /// Converts a raw ICD bitmask into a set of meaningful motor errors.
  /// Intended for use in domain‑layer entities.
  ///
  /// Example:
  ///   final errors = UgvMotorError.fromBitmask(leftMotorErrors);
  static Set<UgvMotorError> fromBitmask(int bitmask) {
    final result = <UgvMotorError>{};
    for (final err in values) {
      if ((bitmask & err.bit) != 0) {
        result.add(err);
      }
    }
    return result;
  }
}

/// Domain wrapper for a left/right motor controller error bitmask.
///
/// Provides a typed, easy‑to‑use view over `UgvMotorError` flags.
class UgvMotorErrorSet {
  /// The set of motor errors represented by this mask.
  final Set<UgvMotorError> errors;

  /// Creates a new motor error set. Prefer `UgvMotorErrorSet.fromBitmask`
  /// when converting from a raw ICD bitmask.
  const UgvMotorErrorSet(this.errors);

  /// Create a `UgvMotorErrorSet` from a raw motor error bitmask.
  ///
  /// Example:
  ///   final leftMotorErrors = UgvMotorErrorSet.fromBitmask(dto.leftMotorErrors);
  static UgvMotorErrorSet fromBitmask(int bitmask) {
    return UgvMotorErrorSet(UgvMotorError.fromBitmask(bitmask));
  }

  /// Returns `true` if MOTOR_OVER_TEMP (bit 1) is set in the bitmask.
  bool hasOverTemp() => errors.contains(UgvMotorError.overTemp);

  /// Returns `true` if MOTOR_OVERLOAD (bit 0) is set in the bitmask.
  bool hasOverLoad() => errors.contains(UgvMotorError.overload);

  /// Returns `true` if MOTOR_OVER_SPEED (bit 2) is set in the bitmask.
  bool hasOverSpeed() => errors.contains(UgvMotorError.overSpeed);

  /// Returns `true` if MOTOR_STALLED (bit 3) is set in the bitmask.
  bool hasStalled() => errors.contains(UgvMotorError.stalled);

  /// Returns `true` if MOTOR_PHASE_LOSS (bit 4) is set in the bitmask.
  bool hasPhaseLoss() => errors.contains(UgvMotorError.phaseLoss);

  /// Returns `true` if MOTOR_HALL_FAULT (bit 5) is set in the bitmask.
  bool hasHallFault() => errors.contains(UgvMotorError.hallFault);

  /// Returns `true` if MOTOR_ENCODER_FAULT (bit 6) is set in the bitmask.
  bool hasEncoderFault() => errors.contains(UgvMotorError.encoderFault);

  /// Returns `true` if MOTOR_BRAKE_FAULT (bit 7) is set in the bitmask.
  bool hasBrakeFault() => errors.contains(UgvMotorError.brakeFault);

  /// Returns `true` if any motor error flag is set.
  bool hasAnyError() => errors.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UgvMotorErrorSet &&
              errors.length == other.errors.length &&
              errors.toSet().containsAll(other.errors);

  @override
  int get hashCode => errors.toSet().hashCode;

  @override
  String toString() => 'UgvMotorErrorSet($errors)';
}