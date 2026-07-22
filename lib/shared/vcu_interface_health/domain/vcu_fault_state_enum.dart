enum VcuFaultState {
  healthy(0, 'NO FAULT'),
  fault(1, 'FAULT'),
  unknown(-1, 'UNKNOWN');

  const VcuFaultState(this.value, this.label);
  final int value;
  final String label;

  static VcuFaultState fromInt(int value) {
    return VcuFaultState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VcuFaultState.unknown,
    );
  }
}
