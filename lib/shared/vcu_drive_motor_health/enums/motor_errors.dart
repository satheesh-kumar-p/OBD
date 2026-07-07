enum MotorErrors {
  overSpeed(128),
  overload(64),
  phaseLoss(32),
  brake(16),
  encoderFault(8),
  overTemp(4),
  hallFault(2),
  stalled(1);

  const MotorErrors(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;
}