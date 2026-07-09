import 'package:flutter/material.dart';

/// General health status for specific radio items (No degraded state)
enum CommHealth { healthy, faulty, unknown }

/// Specialized health status ONLY for Overall Link Health (Supports degraded state)
enum CommOverallHealth { healthy, faulty, degraded, unknown }

enum CommConnection { connected, disconnected, unknown }
enum CommPower { on, off, unknown }

/// Mock entity to allow compilation until the real domain model is ready
class RadioStatusEntity {
  final int? channel1Rssi;
  final int? channel2Rssi;
  final double? snr;

  const RadioStatusEntity({
    this.channel1Rssi,
    this.channel2Rssi,
    this.snr,
  });
}

class CommunicationItemState {
  final String label;
  final String? value;
  final Color color;
  final bool isText;

  const CommunicationItemState({
    required this.label,
    this.value,
    required this.color,
    this.isText = false,
  });

  /// Factory for standard radio items (no degraded state)
  factory CommunicationItemState.fromHealth({
    required String label,
    CommHealth? health,
  }) {
    return CommunicationItemState(
      label: label,
      color: switch (health) {
        CommHealth.healthy => Colors.green,
        CommHealth.faulty => Colors.red,
        _ => Colors.white,
      },
      isText: false,
    );
  }

  /// Factory specifically for Overall Health (supports degraded state)
  factory CommunicationItemState.fromOverallHealth({
    required String label,
    CommOverallHealth? health,
  }) {
    return CommunicationItemState(
      label: label,
      color: switch (health) {
        CommOverallHealth.healthy => Colors.green,
        CommOverallHealth.faulty => Colors.red,
        CommOverallHealth.degraded => Colors.orange,
        _ => Colors.white,
      },
      isText: false,
    );
  }

  factory CommunicationItemState.fromConnection({
    required String label,
    CommConnection? connection,
  }) {
    String valueText = 'UNKNOWN';
    Color textColor = Colors.white;

    if (connection == CommConnection.connected) {
      valueText = 'CONNECTED';
      textColor = Colors.green;
    } else if (connection == CommConnection.disconnected) {
      valueText = 'DISCONNECTED';
      textColor = Colors.red;
    }

    return CommunicationItemState(
      label: label,
      value: valueText,
      color: textColor,
      isText: true,
    );
  }

  factory CommunicationItemState.fromPower({
    required String label,
    CommPower? power,
  }) {
    String valueText = 'UNKNOWN';
    Color textColor = Colors.white;

    if (power == CommPower.on) {
      valueText = 'ON';
      textColor = Colors.green;
    } else if (power == CommPower.off) {
      valueText = 'OFF';
      textColor = Colors.red;
    }

    return CommunicationItemState(
      label: label,
      value: valueText,
      color: textColor,
      isText: true,
    );
  }
}

class CommunicationSectionState {
  final String title;
  final List<CommunicationItemState> items;

  const CommunicationSectionState({
    required this.title,
    required this.items,
  });
}

class CommunicationTileState {
  final String title;
  final List<CommunicationSectionState> sections;

  const CommunicationTileState({
    required this.title,
    required this.sections,
  });
}

class CommunicationState {
  final List<CommunicationTileState> tiles;

  const CommunicationState({
    required this.tiles,
  });

  factory CommunicationState.initial() => CommunicationState(
        tiles: _generateTiles(null),
      );

  factory CommunicationState.fromEntity(RadioStatusEntity entity) {
    return CommunicationState(
      tiles: _generateTiles(entity),
    );
  }

  static List<CommunicationTileState> _generateTiles(RadioStatusEntity? entity) {
    return [
      _buildLBandWidget(entity),
      _buildUhfWidget(),
    ];
  }

  static CommunicationTileState _buildLBandWidget(RadioStatusEntity? entity) {
    return CommunicationTileState(
      title: 'L BAND RADIO',
      sections: [
        _buildLBandRadioUgv(),
        _buildLBandLinkConnection(entity),
        _buildLBandLinkHealth(entity),
      ],
    );
  }

  static CommunicationTileState _buildUhfWidget() {
    return CommunicationTileState(
      title: 'UHF RADIO',
      sections: [
        _buildUhfRadioUgv(),
        _buildUhfLinkConnection(),
        _buildUhfLinkHealth(),
      ],
    );
  }

  // --- L BAND SECTIONS ---

  static CommunicationSectionState _buildLBandRadioUgv() {
    return CommunicationSectionState(
      title: 'L Band Radio - UGV',
      items: [
        CommunicationItemState.fromPower(label: 'Power Status', power: CommPower.on),
        CommunicationItemState.fromHealth(label: 'Overall Health', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Ethernet Communication Fault', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Firmware Fault', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Local RSSI/Noise Fault', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Temperature Fault', health: CommHealth.healthy),
      ],
    );
  }

  static CommunicationSectionState _buildLBandLinkConnection(RadioStatusEntity? entity) {
    final connection = entity == null ? CommConnection.unknown : CommConnection.connected;
    final health = entity == null ? CommHealth.unknown : CommHealth.healthy;
    
    return CommunicationSectionState(
      title: 'L Band Link Connection',
      items: [
        CommunicationItemState.fromConnection(label: 'Overall Status', connection: connection),
        CommunicationItemState.fromHealth(label: 'Heartbeat Fault', health: health),
        CommunicationItemState.fromHealth(label: 'Remote RSSI', health: health),
      ],
    );
  }

  static CommunicationSectionState _buildLBandLinkHealth(RadioStatusEntity? entity) {
    // Dynamic fields from entity
    final int? rssi = entity?.channel1Rssi;
    final int? remoteRssi = entity?.channel2Rssi;
    final double? snr = entity?.snr;

    // Health logic for dynamic fields
    CommHealth getRssiHealth(int? val) {
      if (val == null) return CommHealth.unknown;
      if (val > -90) return CommHealth.healthy;
      return CommHealth.faulty;
    }

    CommOverallHealth getOverallRssiHealth(int? val) {
      if (val == null) return CommOverallHealth.unknown;
      if (val > -90) return CommOverallHealth.healthy;
      if (val >= -105) return CommOverallHealth.degraded;
      return CommOverallHealth.faulty;
    }

    CommHealth getSnrHealth(double? val) {
      if (val == null) return CommHealth.unknown;
      if (val > 20) return CommHealth.healthy;
      return CommHealth.faulty;
    }

    CommOverallHealth getOverallSnrHealth(double? val) {
      if (val == null) return CommOverallHealth.unknown;
      if (val > 20) return CommOverallHealth.healthy;
      if (val >= 10) return CommOverallHealth.degraded;
      return CommOverallHealth.faulty;
    }

    final localRssiHealth = getRssiHealth(rssi);
    final remoteRssiHealth = getRssiHealth(remoteRssi);
    final snrHealth = getSnrHealth(snr);

    final localRssiOverall = getOverallRssiHealth(rssi);
    final remoteRssiOverall = getOverallRssiHealth(remoteRssi);
    final snrOverall = getOverallSnrHealth(snr);

    // Hardcoded fields for now (simulating ICD values)
    const localNoiseHealth = CommHealth.healthy;
    const remoteNoiseHealth = CommHealth.unknown;
    const packetLossHealth = CommHealth.healthy;
    const heartbeatTimeoutHealth = CommHealth.healthy;

    // Overall Health Calculation
    CommOverallHealth overallHealth;
    if (localRssiOverall == CommOverallHealth.unknown || remoteRssiOverall == CommOverallHealth.unknown || snrOverall == CommOverallHealth.unknown) {
      overallHealth = CommOverallHealth.unknown;
    } else if (localRssiOverall == CommOverallHealth.healthy && remoteRssiOverall == CommOverallHealth.healthy && snrOverall == CommOverallHealth.healthy) {
      overallHealth = CommOverallHealth.healthy;
    } else if (localRssiOverall == CommOverallHealth.faulty || remoteRssiOverall == CommOverallHealth.faulty || snrOverall == CommOverallHealth.faulty) {
      overallHealth = CommOverallHealth.faulty;
    } else {
      overallHealth = CommOverallHealth.degraded;
    }

    return CommunicationSectionState(
      title: 'L Band Link Health',
      items: [
        CommunicationItemState.fromOverallHealth(label: 'Overall Health', health: overallHealth),
        CommunicationItemState.fromHealth(
          label: 'Local RSSI Fault ${rssi != null ? "($rssi dBm)" : ""}', 
          health: localRssiHealth,
        ),
        CommunicationItemState.fromHealth(
          label: 'Remote RSSI Fault ${remoteRssi != null ? "($remoteRssi dBm)" : ""}', 
          health: remoteRssiHealth,
        ),
        CommunicationItemState.fromHealth(label: 'Local Noise Fault', health: localNoiseHealth),
        CommunicationItemState.fromHealth(label: 'Remote Noise Fault', health: remoteNoiseHealth),
        CommunicationItemState.fromHealth(
          label: 'SNR Fault ${snr != null ? "(${snr.toStringAsFixed(1)} dB)" : ""}', 
          health: snrHealth,
        ),
        CommunicationItemState.fromHealth(label: 'Packet Loss Fault', health: packetLossHealth),
        CommunicationItemState.fromHealth(label: 'Heartbeat Timeout Fault', health: heartbeatTimeoutHealth),
      ],
    );
  }

  // --- UHF SECTIONS ---

  static CommunicationSectionState _buildUhfRadioUgv() {
    return CommunicationSectionState(
      title: 'UHF Radio - UGV',
      items: [
        CommunicationItemState.fromPower(label: 'Power Status', power: CommPower.off),
        CommunicationItemState.fromHealth(label: 'Overall Health', health: CommHealth.unknown),
        CommunicationItemState.fromHealth(label: 'UART Communication Fault', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Firmware Fault', health: CommHealth.faulty),
        CommunicationItemState.fromHealth(label: 'Local RSSI/Noise Fault', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Temperature Fault', health: CommHealth.healthy),
      ],
    );
  }

  static CommunicationSectionState _buildUhfLinkConnection() {
    return CommunicationSectionState(
      title: 'UHF Link Connection',
      items: [
        CommunicationItemState.fromConnection(label: 'Overall Status', connection: CommConnection.disconnected),
        CommunicationItemState.fromHealth(label: 'Heartbeat Fault', health: CommHealth.faulty),
        CommunicationItemState.fromHealth(label: 'Remote RSSI', health: CommHealth.unknown),
      ],
    );
  }

  static CommunicationSectionState _buildUhfLinkHealth() {
    return CommunicationSectionState(
      title: 'UHF Link Health',
      items: [
        CommunicationItemState.fromOverallHealth(label: 'Overall Health', health: CommOverallHealth.degraded),
        CommunicationItemState.fromHealth(label: 'Local RSSI Fault', health: CommHealth.faulty),
        CommunicationItemState.fromHealth(label: 'Remote RSSI Fault', health: CommHealth.unknown),
        CommunicationItemState.fromHealth(label: 'Local Noise Fault', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Remote Noise Fault', health: CommHealth.unknown),
        CommunicationItemState.fromHealth(label: 'SNR Fault', health: CommHealth.healthy),
        CommunicationItemState.fromHealth(label: 'Packet Loss Fault', health: CommHealth.faulty),
        CommunicationItemState.fromHealth(label: 'Heartbeat Timeout Fault', health: CommHealth.healthy),
      ],
    );
  }
}
