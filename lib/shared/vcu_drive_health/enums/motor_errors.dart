enum MotorErrors {
  overSpeed(1),
  overload(2),
  phaseLoss(4),
  brake(8),
  encoderFault(16),
  overTemp(32),
  hallFault(64),
  stalled(128);

  const MotorErrors(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;
}