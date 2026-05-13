class HeartbeatEntity {
  static const int _kHeartbeatStaleTime = 3;

  const HeartbeatEntity({
    required this.linkId,
    required this.systemId,
    required this.type,
    required this.autopilot,
    required this.baseMode,
    required this.customMode,
    required this.systemStatus,
    required this.receivedAt,
  });

  final String linkId;
  final int systemId;
  final int type;
  final int autopilot;
  final int baseMode; // MAV_MODE_FLAG bitmap (Always 0)
  final int customMode; /// Indicates Main Mode (Mode A, Mode B)
  final int systemStatus; // MAV_STATE (Always 4)
  final DateTime receivedAt;

  bool get isStale =>
      DateTime.now().difference(receivedAt).inSeconds > _kHeartbeatStaleTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HeartbeatEntity &&
              other.linkId == linkId &&
              other.systemId == systemId &&
              other.type == type &&
              other.autopilot == autopilot;

  @override
  int get hashCode =>
      Object.hash(linkId, systemId, type, autopilot);

  @override
  String toString() {
    return 'HeartbeatEntity('
        'linkId: $linkId, '
        'systemId: $systemId, '
        'type: $type, '
        'autopilot: $autopilot, '
        'baseMode: 0x${baseMode.toRadixString(16)}, '
        'systemStatus: $systemStatus, '
        'receivedAt: $receivedAt)';
  }
}