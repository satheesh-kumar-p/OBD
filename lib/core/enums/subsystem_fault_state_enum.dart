enum SubsystemFaultState {
  unknown(0, 'UNKNOWN'),
  healthy(1, 'HEALTHY'),
  faulty(2, 'FAULTY');

  const SubsystemFaultState(this.value, this.label);
  final int value;
  final String label;

  static SubsystemFaultState fromInt(int value) {
    return SubsystemFaultState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SubsystemFaultState.unknown,
    );
  }
}

enum GnssFaultState {
  unknown(0, 'UNKNOWN'),
  healthy(1, 'HEALTHY'),
  degraded(2, 'DEGRADED'),
  faulty(3, 'FAULTY');

  const GnssFaultState(this.value, this.label);
  final int value;
  final String label;

  static GnssFaultState fromInt(int value) {
    return GnssFaultState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GnssFaultState.unknown,
    );
  }
}
