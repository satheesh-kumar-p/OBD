enum SecComputeStatus {
  healthy(0, 'HEALTHY'),
  fault(1, 'FAULT'),
  unknown(-1, 'UNKNOWN');

  const SecComputeStatus(this.value, this.label);
  final int value;
  final String label;

  static SecComputeStatus fromInt(int value) {
    return SecComputeStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SecComputeStatus.unknown,
    );
  }
}

enum SecInterfaceStatus {
  inactive(0, 'INACTIVE'),
  active(1, 'ACTIVE'),
  unknown(-1, 'UNKNOWN');

  const SecInterfaceStatus(this.value, this.label);
  final int value;
  final String label;

  static SecInterfaceStatus fromInt(int value) {
    return SecInterfaceStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SecInterfaceStatus.unknown,
    );
  }
}
