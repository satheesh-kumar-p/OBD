enum HvBatteryFaults {
  singleCellOvervoltage(1 << 14),      // Bit 46
  singleCellUndervoltage(1 << 13),     // Bit 45
  packOvervoltage(1 << 12),            // Bit 44
  packUndervoltage(1 << 11),           // Bit 43
  chargeOverTemperature(1 << 10),      // Bit 42
  chargeLowTemperature(1 << 9),        // Bit 41
  dischargeOverTemperature(1 << 8),    // Bit 40
  dischargeLowTemperature(1 << 7),     // Bit 39
  chargeOvercurrent(1 << 6),           // Bit 38
  dischargeOvercurrent(1 << 5),        // Bit 37
  shortCircuitProtection(1 << 4),      // Bit 36
  frontDetectionIcError(1 << 3),       // Bit 35
  softwareLockMos(1 << 2),             // Bit 34
  cycleLifeFault(1 << 1),              // Bit 33
  capacityFault(1 << 0);               // Bit 32

  const HvBatteryFaults(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;
}
