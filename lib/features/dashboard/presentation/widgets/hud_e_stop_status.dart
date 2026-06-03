import 'package:flutter/material.dart';

import '../../enums/e_stop_status_enum.dart';

class HudEStopStatus extends StatelessWidget {
  const HudEStopStatus({
    super.key,
    required this.height,
    required this.color,
    this.size,
    this.gapAfter = 12.0,
    this.status,
  });

  final double height;
  final Color color;
  final double? size;
  final double gapAfter;
  final EStopStatus? status;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? (height * 0.55).clamp(14.0, 32.0).toDouble();

    final statusColor = switch (status) {
      EStopStatus.engaged => const Color(0xFFFF3B3B),
      EStopStatus.released => const Color(0xFF00FF66),
      EStopStatus.unknown || null => color.withOpacity(0.3),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.dangerous_outlined,
          size: iconSize,
          color: statusColor,
        ),
        SizedBox(width: gapAfter),
      ],
    );
  }
}
