enum SensorFaultStatus {
  healthy(0, 'HEALTHY'),
  fault(1, 'FAULT'),
  unknown(-1, 'UNKNOWN');

  const SensorFaultStatus(this.value, this.label);
  final int value;
  final String label;

  static SensorFaultStatus fromInt(int value) {
    return SensorFaultStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SensorFaultStatus.unknown,
    );
  }
}

enum SensorConnectionStatus {
  unknown(0, 'UNKNOWN'),
  connected(1, 'CONNECTED'),
  disconnected(2, 'DISCONNECTED');

  const SensorConnectionStatus(this.value, this.label);
  final int value;
  final String label;

  static SensorConnectionStatus fromInt(int value) {
    return SensorConnectionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SensorConnectionStatus.unknown,
    );
  }
}

enum SensorLinkHealth {
  unknown(0, 'UNKNOWN'),
  healthy(1, 'HEALTHY'),
  degraded(2, 'DEGRADED'),
  faulty(3, 'FAULTY');

  const SensorLinkHealth(this.value, this.label);
  final int value;
  final String label;

  static SensorLinkHealth fromInt(int value) {
    return SensorLinkHealth.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SensorLinkHealth.unknown,
    );
  }
}

enum CameraStatus {
  unknown(0, 'UNKNOWN'),
  healthy(1, 'HEALTHY'),
  faulty(2, 'FAULTY');

  const CameraStatus(this.value, this.label);
  final int value;
  final String label;

  static CameraStatus fromInt(int value) {
    return CameraStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CameraStatus.unknown,
    );
  }
}
