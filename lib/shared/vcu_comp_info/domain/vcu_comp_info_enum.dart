enum VcuCompInfoStatus {
  healthy(0, 'HEALTHY'),
  fault(1, 'FAULT'),
  unknown(-1, 'UNKNOWN');

  const VcuCompInfoStatus(this.value, this.label);
  final int value;
  final String label;

  static VcuCompInfoStatus fromInt(int value) {
    return VcuCompInfoStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VcuCompInfoStatus.unknown,
    );
  }
}
