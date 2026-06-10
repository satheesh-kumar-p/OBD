import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LV Battery
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BatteryWidget(
              soc: lvBatterySoc,
              height: h,
              color: _getBatteryColor(lvBatterySoc),
              label: 'LV',
            ),
            SizedBox(height: 4.h),
            Text(
              'LV',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        // HV Battery
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BatteryWidget(
              soc: hvBatterySoc,
              height: h,
              color: _getBatteryColor(hvBatterySoc),
              label: 'HV',
            ),
            SizedBox(height: 4.h),
            Text(
              'HV',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getBatteryColor(int soc) {
    if (soc < 20) return const Color(0xFFFF3B3B); // Red
    if (soc < 50) return const Color(0xFFFFB347); // Orange
    return const Color(0xFF00FF66); // Green
  }
}

class _BatteryWidget extends StatelessWidget {
  final int soc;
  final double height;
  final Color color;
  final String label;

  const _BatteryWidget({
    required this.soc,
    required this.height,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final unit = height / 20.0;
    final double width = 34.0 * unit;
    final clampedLevel = (soc / 100.0).clamp(0.0, 1.0);

    return _buildStandardBattery(unit, width, height, clampedLevel);
  }

  Widget _buildStandardBattery(double unit, double w, double h, double level) {
    final borderW = 1.5 * unit;
    final borderRadius = 2.0 * unit;
    final terminalW = 2.5 * unit;
    final terminalH = 7.0 * unit;
    final inset = 1.0 * unit;

    return Row(
      mainAxisSize: MainAxisSize.min,
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
                  width: (w - 2 * inset - borderW) * level,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1.0 * unit),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '$soc%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: h * 0.6,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: terminalW,
          height: terminalH,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(1.5 * unit),
              bottomRight: Radius.circular(1.5 * unit),
            ),
          ),
        ),
      ],
    );
  }
}
