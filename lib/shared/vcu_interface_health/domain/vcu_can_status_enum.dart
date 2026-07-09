enum VcuCanStatus {
  on(0, 'ON'),
  off(1, 'OFF'),
  unknown(-1, 'UNKNOWN');

  const VcuCanStatus(this.value, this.label);
  final int value;
  final String label;

  static VcuCanStatus fromInt(int value) {
    return VcuCanStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VcuCanStatus.unknown,
    );
  }
}
