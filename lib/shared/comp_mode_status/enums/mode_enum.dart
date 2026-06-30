enum MainMode {
  unknown(-1, 'UNKNOWN'),
  modeA(1, 'MODE A'),
  modeB(2, 'MODE B'),
  modeC(3, 'MODE C'),
  modeD(4, 'MODE D'),
  modeE(5, 'MODE E');

  const MainMode(this.value, this.label);
  final int value;
  final String label;
}

enum HoldSubMode {
  unknown(-1, 'UNKNOWN'),
  disabled(1, 'DISABLED'),
  enabled(2, 'ENABLED');

  const HoldSubMode(this.value, this.label);
  final int value;
  final String label;
}

enum SpeedMode {
  unknown(-1, 'UNKNOWN'),
  low(1, 'LOW'),
  medium(2, 'MEDIUM'),
  high(3, 'HIGH');

  const SpeedMode(this.value, this.label);
  final int value;
  final String label;
}

enum DriveMode {
  unknown(-1, 'UNKNOWN'),
  speed(1, 'SPEED'),
  torque(2, 'TORQUE'),
  torqueWithSpeedLimit(3, 'TRQ W SL'),
  position(4, 'POSITION');

  const DriveMode(this.value, this.label);
  final int value;
  final String label;
}

enum ArmStatus {
  unknown(-1, 'UNKNOWN'),
  disarmed(1, 'DISARMED'),
  armed(2, 'ARMED'),
  override(3, 'OVERRIDE');

  const ArmStatus(this.value, this.label);
  final int value;
  final String label;
}
