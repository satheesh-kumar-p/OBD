enum LinkStatusLevel { connected, unknown, lost }

extension LinkStatusLevelX on LinkStatusLevel {
  bool get isHealthy => this == LinkStatusLevel.connected;

  String get label => switch (this) {
    LinkStatusLevel.connected => 'Connected',
    LinkStatusLevel.unknown => 'No Heartbeat',
    LinkStatusLevel.lost => 'Disconnected',
  };
}

class LinkStatusEntity {
  const LinkStatusEntity({
    required this.linkId,
    required this.isConnected,
  });

  final String linkId;
  final bool isConnected;

  LinkStatusEntity copyWith({bool? isConnected}) => LinkStatusEntity(
    linkId: linkId,
    isConnected: isConnected ?? this.isConnected,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LinkStatusEntity &&
              other.linkId == linkId &&
              other.isConnected == isConnected;

  @override
  int get hashCode => Object.hash(linkId, isConnected);

  @override
  String toString() =>
      'LinkStatusEntity(linkId: $linkId, isConnected: $isConnected)';
}