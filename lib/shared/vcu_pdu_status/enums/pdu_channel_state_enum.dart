enum PduFaultEnum {
  healthy(0, 'HEALTHY'),
  fault(1, 'FAULT'),
  unknown(-1, 'UNKNOWN');

  const PduFaultEnum(this.value, this.label);
  final int value;
  final String label;

  static PduFaultEnum fromInt(int value) {
    return PduFaultEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PduFaultEnum.unknown,
    );
  }
}
