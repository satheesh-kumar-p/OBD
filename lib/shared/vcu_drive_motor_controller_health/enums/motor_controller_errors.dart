enum MotorControllerErrors {
  canCommunication(1),
  overTemp(2),
  busVoltage(4),
  uartCommunication(8),
  underVoltage(16),
  overVoltage(32),
  overCurrent(64),
  drive(128);

  const MotorControllerErrors(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;

}
