enum PduChannelState {
  healthy(0, 'HEALTHY'),
  fault(1, 'FAULT'),
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
