enum PduChannelState {
  off(0, 'OFF'),
  on(1, 'ON'),
  unknown(-1, 'UNKNOWN');

  const PduChannelState(this.value, this.label);
  final int value;
  final String label;

  static PduChannelState fromInt(int value) {
    return PduChannelState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PduChannelState.unknown,
    );
  }
}
