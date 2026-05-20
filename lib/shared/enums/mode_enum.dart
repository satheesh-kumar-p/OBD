enum MainMode {
  unknown(-1), // Invalid values
  modeA(1), // 1 = MODE_A
  modeB(2); // 2 = MODE_B

  const MainMode(this.value);
  final int value;
}

enum SubMode {
  unknown(-1), // Invalid values
  none(0),
  hold(10);

  const SubMode(this.value);
  final int value;
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