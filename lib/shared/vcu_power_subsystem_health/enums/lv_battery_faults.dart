enum LvBatteryFaults {
  deepDischarge(1 << 3),               // Bit 31
  underVoltage(1 << 2),                // Bit 30
  overVoltage(1 << 1),                 // Bit 29
  loadFault(1 << 0);                   // Bit 28

  const LvBatteryFaults(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;
}
