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

enum Sensor1Faults {
  uartComm(1 << 12),
  firmware(1 << 11),
  localRssi(1 << 10),
  temp(1 << 9),
  linkConHb(1 << 8),
  linkConRemoteRssi(1 << 7),
  healthLocalRssi(1 << 6),
  healthRemoteRssi(1 << 5),
  healthLocalNoise(1 << 4),
  healthRemoteNoise(1 << 3),
  healthSnr(1 << 2),
  healthPackLoss(1 << 1),
  healthHbTimeout(1 << 0);

  const Sensor1Faults(this.bit);
  final int bit;

  bool isFaulty(int rawValue) => (rawValue & bit) != 0;
}
