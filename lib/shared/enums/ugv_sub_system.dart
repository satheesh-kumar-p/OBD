enum UgvSubsystem {
  compute(1),
  vcu(2),
  leftMotor(4),
  rightMotor(8),
  bms(16),
  pdu(32),
  uhfRadio(64),
  display(128),
  handCtrl(256),
  gcs(512);

  const UgvSubsystem(this.bit);
  final int bit;

  static Set<UgvSubsystem> fromBitmask(int bitmask) {
    final result = <UgvSubsystem>{};
    for (final sub in values) {
      if ((bitmask & sub.bit) != 0) {
        result.add(sub);
      }
    }
    return result;
  }
}