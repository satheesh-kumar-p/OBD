import 'package:flutter/material.dart';

class HudDateTimeLabel extends StatelessWidget {
  const HudDateTimeLabel({super.key, required this.height, required this.systemTime});

  final double height;
  final String systemTime;

  @override
  Widget build(BuildContext context) {
    final h = height;
    final fontSize = (h * 0.44).clamp(10.0, 18.0);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        systemTime,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          height: 1,
          decoration: TextDecoration.none,
          shadows: const [
            Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 1)),
          ],
        ),
      ),
    );
  }
}