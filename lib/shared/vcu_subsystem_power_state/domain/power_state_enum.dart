enum PowerState {
  unknown(0, 'UNKNOWN'),
  on(1, 'ON'),
  off(2, 'OFF');

  const PowerState(this.value, this.label);
  final int value;
  final String label;

  static PowerState fromInt(int value) {
    return PowerState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PowerState.unknown,
    );
  }
}
