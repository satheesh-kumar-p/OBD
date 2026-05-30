import 'package:flutter/material.dart';

class HudBatteryStatusIcon extends StatelessWidget {
  const HudBatteryStatusIcon({
    super.key,
    required this.size,
    required this.soc,
    required this.voltage,
  });

  final double size;
  final int soc;
  final double voltage;

  @override
  Widget build(BuildContext context) {
    final h = size;
    final unit = h / 20.0;
    // Slimmer battery icon for 5" screen
    final w = 34.0 * unit;
    final clampedLevel = (soc / 100.0).clamp(0.0, 1.0);

    var batteryColor = const Color(0xFF1BFA60); // Default healthy green
    if (clampedLevel < 0.2) {
      batteryColor = Colors.redAccent;
    } else if (clampedLevel < 0.5) {
      batteryColor = Colors.orangeAccent;
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Voltage Display - High visibility CyanAccent and larger font
        Text(
          '${voltage.toStringAsFixed(1)} V',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: h * 0.85, // Even larger for 5" display visibility
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
                          boxShadow: [
                            BoxShadow(
                              color: batteryColor.withOpacity(0.4),
                              blurRadius: 5 * unit,
                              spreadRadius: 1.5 * unit,
                            )
                          ],
                        ),
                      ),
                    ),
                    // SOC Percentage Text Overlay - High contrast and large font
                    Center(
                      child: Text(
                        '$soc',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: h * 0.9, // Significantly increased for visibility
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          shadows: const [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black,
                              offset: Offset(-2.0, -2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Positive Terminal
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
        ),
      ],
    );
  }
}
