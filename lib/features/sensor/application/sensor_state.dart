import 'package:flutter/material.dart';

/// General health status for all sensors except GNSS Overall Health
enum SensorHealth { healthy, faulty, unknown }

/// Specialized health status ONLY for GNSS Overall Health
enum GnssHealth { healthy, faulty, degraded, unknown }

enum SensorPower { on, off, unknown }

class SensorItemState {
  final String label;
  final String? value;
  final Color color;
  final bool isText;

  const SensorItemState({
    required this.label,
    this.value,
    required this.color,
    this.isText = false,
  });

  /// Factory for standard sensor items (no degraded state)
  factory SensorItemState.fromHealth({
    required String label,
    SensorHealth? health,
  }) {
    return SensorItemState(
      label: label,
      color: switch (health) {
        SensorHealth.healthy => Colors.green,
        SensorHealth.faulty => Colors.red,
        _ => Colors.white,
      },
      isText: false,
    );
  }

  /// Factory specifically for GNSS Overall Health (supports degraded state)
  factory SensorItemState.fromGnssHealth({
    required String label,
    GnssHealth? health,
  }) {
    return SensorItemState(
      label: label,
      color: switch (health) {
        GnssHealth.healthy => Colors.green,
        GnssHealth.faulty => Colors.red,
        GnssHealth.degraded => Colors.orange,
        _ => Colors.white,
      },
      isText: false,
    );
  }

  factory SensorItemState.fromPower({
    required String label,
    SensorPower? power,
  }) {
    String valueText = 'UNKNOWN';
    Color textColor = Colors.white;

    if (power == SensorPower.on) {
      valueText = 'ON';
      textColor = Colors.green;
    } else if (power == SensorPower.off) {
      valueText = 'OFF';
      textColor = Colors.red;
    }

    return SensorItemState(
      label: label,
      value: valueText,
      color: textColor,
      isText: true,
    );
  }
}

class SensorTileState {
  final String title;
  final List<SensorItemState> items;

  const SensorTileState({
    required this.title,
    required this.items,
  });
}

class SensorScreenState {
  final List<SensorTileState> tiles;

  const SensorScreenState({
    required this.tiles,
  });
}
