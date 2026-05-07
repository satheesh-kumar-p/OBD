enum UgvMainMode {
  modeA(0), // 0 = MODE_A
  modeB(1); // 1 = MODE_B

  const UgvMainMode(this.value);
  final int value;
}

enum UgvSubMode {
  none(0),
  hold(10);

  const UgvSubMode(this.value);
  final int value;
}

enum ModeChangeReason {
  gcsCommand(0),
  failsafe(1),
  sensorFault(2),
  commLoss(3);

  const ModeChangeReason(this.value);
  final int value;
}