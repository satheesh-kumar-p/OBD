import 'package:flutter/material.dart';

class HudHandctrlStatus extends StatelessWidget {
  const HudHandctrlStatus({
    super.key,
    required this.height,
    required this.statusText,
    this.isHealthy,
    this.statusSlotWidth,
    this.gapAfter = 12.0,
  });

  final double height;
  
  /// Text to show for the current HandCtrl status (e.g. "HEALTHY", "NOT HEALTHY", "---").
  final String statusText;
  
  /// Whether the status is healthy. Used only for coloring.
  /// - true: green
  /// - false/null: white
  final bool? isHealthy;

  
  final double? statusSlotWidth;

  final double gapAfter;

  @override
  Widget build(BuildContext context) {
    final fontSize = (height * 0.44).clamp(10.0, 18.0);
    final style = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
      height: 1,
      decoration: TextDecoration.none,
      shadows: const [
        Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 1)),
      ],
    );

    final slotW = statusSlotWidth ??
      (height * 3.0).clamp(84.0, 220.0).toDouble();
    
    final statusStyle = style.copyWith(
      color: switch (statusText) {
        'HEALTHY' => const Color(0xFF74FF9F),
        'UNHEALTHY' => Colors.red,
        'NO COMM' || 'NO COMMUNICATION' => Colors.white,
        _ => (isHealthy ?? false) ? const Color(0xFF74FF9F) : Colors.white,
      },
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('HANDCONTROLLER STATUS:', style: style),
        SizedBox(width: (height * 0.2).clamp(4.0, 12.0).toDouble()),
        SizedBox(
          width: slotW,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                statusText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: statusStyle,
              ),
            ),
          ),
        ),
        SizedBox(width: gapAfter),
      ],
    );
  }
}