import 'package:flutter/material.dart';

class HudBatteryStatusIcon extends StatelessWidget {
  const HudBatteryStatusIcon({
    super.key,
    required this.size,
    double? percentage,
  }) : level = percentage ?? 1.0;

  final double size;
  final double level;

  @override
  Widget build(BuildContext context) {
    final h = size;
    final unit = h / 20.0;
    // Slimmer battery icon for 5" screen
    final w = 34.0 * unit; 
    final clampedLevel = level.clamp(0.0, 1.0);

    var batteryColor = Colors.green;
    if (clampedLevel < 0.2) {
      batteryColor = Colors.red;
    } else if (clampedLevel < 0.5) {
      batteryColor = Colors.orange;
    }

    final borderW = 1.5 * unit;
    final borderRadius = 2.0 * unit;
    final inset = 1.0 * unit;
    final fillRadius = 1.0 * unit;

    final terminalW = 2.5 * unit;
    final terminalH = 7.0 * unit;
    final terminalTop = 6.5 * unit;
    final terminalRadius = 1.5 * unit;

    final fillMaxW = w - 2 * inset - borderW;
    final fillW = (fillMaxW * clampedLevel).clamp(0.0, fillMaxW);

    return SizedBox(
      width: w + terminalW,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: borderW),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: inset,
                  top: inset,
                  bottom: inset,
                  child: Container(
                    width: fillW,
                    decoration: BoxDecoration(
                      color: batteryColor,
                      borderRadius: BorderRadius.circular(fillRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -terminalW + 0.5 * unit,
            top: terminalTop,
            child: Container(
              width: terminalW,
              height: terminalH,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(terminalRadius),
                  bottomRight: Radius.circular(terminalRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
