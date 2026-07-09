enum LvPduChannelFaults {
  shortCircuit(1 << 2),      // Bit 2 of the 3-bit channel range
  currentLimit(1 << 1),     // Bit 1 of the 3-bit channel range
  openCircuit(1 << 0);      // Bit 0 of the 3-bit channel range

  const LvPduChannelFaults(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;
}
