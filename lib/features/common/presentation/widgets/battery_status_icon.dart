import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../state/common_screen_state.dart';

class BatteryStatus extends StatelessWidget {
  final BatteryIndicatorState state;

  const BatteryStatus({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60.w,
          height: 38.h,
          child: _BatteryLevelIndicator(
            soc: state.soc,
            color: state.color,
            isCharging: state.isCharging,
          ),
        ),
        Text(
          state.label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _BatteryLevelIndicator extends StatelessWidget {
  final int soc;
  final Color color;
  final bool isCharging;

  const _BatteryLevelIndicator({
    required this.soc,
    required this.color,
    this.isCharging = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final totalWidth = constraints.maxWidth;
        final unit = height / 20.0;

        final terminalW = 3.0 * unit;
        final width = totalWidth - terminalW;
        final clampedLevel = (soc / 100.0).clamp(0.0, 1.0);

        final borderW = 1.2 * unit;
        final borderRadius = 4.0 * unit;
        final terminalH = 12.0 * unit;
        final inset = 2.0 * unit;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.batteryEmpty,
                border: Border.all(
                  color: isCharging ? AppColors.success : AppColors.textPrimary.withOpacity(0.4),
                  width: borderW,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Battery Fill
                  Positioned(
                    left: inset,
                    top: inset,
                    bottom: inset,
                    child: Container(
                      width: (width - 2 * inset - borderW) * clampedLevel,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(1.5 * unit),
                      ),
                    ),
                  ),
                  // SOC Text & Icon
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: inset + unit),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isCharging)
                                Icon(
                                  Icons.bolt_rounded,
                                  color: AppColors.batteryText,
                                  size: height * 0.65,
                                ),
                              Text(
                                '$soc%',
                                style: TextStyle(
                                  color: AppColors.batteryText,
                                  fontSize: height * 0.8,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Battery Terminal (Tip)
            Container(
              width: terminalW,
              height: terminalH,
              decoration: BoxDecoration(
                color: isCharging ? AppColors.success : AppColors.textPrimary.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(2.5 * unit),
                  bottomRight: Radius.circular(2.5 * unit),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
