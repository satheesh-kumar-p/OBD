enum HandcontrollerStatus {
  healthy,
  unhealthy,
  noCommunication,
  unknown,
}

class HandcontrollerStatusEntity {
  const HandcontrollerStatusEntity({
    required this.status,
    required this.receivedAt,
  });

  final HandcontrollerStatus status;
  final DateTime receivedAt;

  @override
  String toString() =>
      'HandcontrollerStatusEntity(status: $status, receivedAt: $receivedAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HandcontrollerStatusEntity &&
          other.status == status &&
          other.receivedAt == receivedAt;

  @override
  int get hashCode => Object.hash(status, receivedAt);
}
