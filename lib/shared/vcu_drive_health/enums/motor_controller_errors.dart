enum MotorControllerErrors {
  drive(1),
  overCurrent(2),
  underPressure(4),
  underVoltage(8),
  overTemp(16),
  canCommunication(32);

  const MotorControllerErrors(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;

}
