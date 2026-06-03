enum MainMode {
  unknown(-1, 'UNKNOWN'),
  modeA(1, 'MODE A'),
  modeB(2, 'MODE B');

  const MainMode(this.value, this.label);
  final int value;
  final String label;
}

enum SubMode {
  unknown(-1, 'UNKNOWN'),
  none(0, 'NONE'),
  hold(10, 'HOLD');

  const SubMode(this.value, this.label);
  final int value;
  final String label;
}

enum ModeChangeReason {
  unknown(-1), // Invalid values
  gcsCommand(0),
  failsafe(1),
  sensorFault(2),
  commLoss(3);

  const ModeChangeReason(this.value);
  final int value;
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
