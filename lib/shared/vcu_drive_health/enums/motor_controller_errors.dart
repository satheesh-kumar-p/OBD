enum MotorControllerErrors {
  canCommunication(1),
  overTemp(2),
  underVoltage(4),
  overPressure(8),
  overCurrent(16),
  drive(32);

  const MotorControllerErrors(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;

}
