enum PowerSubsystemStatus {
  healthy(0, 'HEALTHY'),
  fault(1, 'FAULT'),
  unknown(-1, 'UNKNOWN');

  const PowerSubsystemStatus(this.value, this.label);
  final int value;
  final String label;

  static PowerSubsystemStatus fromInt(int value) {
    return PowerSubsystemStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PowerSubsystemStatus.unknown,
    );
  }
}
