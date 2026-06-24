enum HvBatteryFaults {
  singleCellOvervoltage(1 << 12),      // Bit 46
  singleCellUndervoltage(1 << 11),     // Bit 45
  packOvervoltage(1 << 10),            // Bit 44
  packUndervoltage(1 << 9),            // Bit 43
  chargeOverTemperature(1 << 8),       // Bit 42
  chargeLowTemperature(1 << 7),        // Bit 41
  dischargeOverTemperature(1 << 6),    // Bit 40
  dischargeLowTemperature(1 << 5),     // Bit 39
  chargeOvercurrent(1 << 4),           // Bit 38
  dischargeOvercurrent(1 << 3),        // Bit 37
  shortCircuitProtection(1 << 2),      // Bit 36
  frontDetectionIcError(1 << 1),       // Bit 35
  softwareLockMos(1 << 0);             // Bit 34

  const HvBatteryFaults(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;
}
