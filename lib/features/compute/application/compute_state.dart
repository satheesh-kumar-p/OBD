import 'package:flutter/material.dart';

/// The 'Typed Entity' layer (Enums representing raw ICD values)
enum ComputeHealth { healthy, faulty, unknown }

enum JetsonPower { on, off, unknown }

/// The 'State' layer (Dumb UI params ready for the Screen)
class ComputeItemState {
  final String label;
  final String? value;
  final Color color;
  final bool isText;

  const ComputeItemState({
    required this.label,
    this.value,
    required this.color,
    this.isText = false,
  });

  /// Logic for driving UI params lives here in the State layer
  factory ComputeItemState.fromHealth({
    required String label,
    ComputeHealth? health,
  }) {
    return ComputeItemState(
      label: label,
      color: switch (health) {
        ComputeHealth.healthy => Colors.green,
        ComputeHealth.faulty => Colors.red,
        _ => Colors.white, // Default/Unknown/Null is white
      },
      isText: false,
    );
  }

  factory ComputeItemState.fromPower({
    required String label,
    JetsonPower? power,
  }) {
    String valueText = 'UNKNOWN';
    Color textColor = Colors.white;

    if (power == JetsonPower.on) {
      valueText = 'ON';
      textColor = Colors.green;
    } else if (power == JetsonPower.off) {
      valueText = 'OFF';
      textColor = Colors.red;
    }

    return ComputeItemState(
      label: label,
      value: valueText,
      color: textColor,
      isText: true,
    );
  }
}

class ComputeTileState {
  final String title;
  final List<ComputeItemState> items;

  const ComputeTileState({
    required this.title,
    required this.items,
  });
}

class ComputeScreenState {
  final List<ComputeTileState> tiles;

  const ComputeScreenState({
    required this.tiles,
  });
}
