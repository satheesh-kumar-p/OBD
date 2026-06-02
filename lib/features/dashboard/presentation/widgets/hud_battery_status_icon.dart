import 'package:flutter/material.dart';

class HudBatteryStatusIcon extends StatelessWidget {
  const HudBatteryStatusIcon({
    super.key,
    required this.size,
    required this.hvBatterySoc,
    required this.lvBatterySoc,
  });

  final double size;
  final int hvBatterySoc;
  final int lvBatterySoc;

  @override
  Widget build(BuildContext context) {
    final h = size;
    final unit = h / 20.0;
    // Slimmer battery icon for 5" screen
    final w = 34.0 * unit;
    final clampedLevel = (hvBatterySoc / 100.0).clamp(0.0, 1.0);

    var batteryColor = const Color(0xFF00FF66); // Standard Healthy Green
    if (clampedLevel < 0.2) {
      batteryColor = const Color(0xFFFF3B3B); // Standard Alert Red
    } else if (clampedLevel < 0.5) {
      batteryColor = const Color(0xFFFFB347); // Standard Warning Orange
    }

    final borderW = 1.5 * unit;
    final borderRadius = 2.0 * unit;
    final inset = 1.0 * unit;
    final fillRadius = 1.0 * unit;

    final terminalW = 2.5 * unit;
    final terminalH = 7.0 * unit;
    final terminalTop = (h - terminalH) / 2; // Perfectly centered vertically
    final terminalRadius = 1.5 * unit;

    final fillMaxW = w - 2 * inset - borderW;
    final fillW = (fillMaxW * clampedLevel).clamp(0.0, fillMaxW);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$lvBatterySoc%',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: h * 0.6,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(width: 10 * unit),
        // Battery Body
        SizedBox(
          width: w + terminalW,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Outer Shell
              Container(
                width: w,
                height: h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: borderW),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Dynamic Fill
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
                    // SOC Percentage Text Overlay - High contrast and large font
                    Center(
                      child: Text(
                        '$hvBatterySoc%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: h * 0.7, // Adjusted for better centering fit
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          height: 1.0, // Force line height to 1.0 for precise centering
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Positive Terminal
              Positioned(
                right: 0,
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
        ),
      ],
    );
  }
}
