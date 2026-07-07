import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../common_providers.dart';

class BatteryStatusIcon extends ConsumerWidget {
  const BatteryStatusIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicators = ref.watch(commonScreenStateProvider.select((s) => s.batteryIndicators));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BatteryLevelIndicator(
              soc: indicators[0].soc,
              color: indicators[0].color,
              isCharging: indicators[0].isCharging,
            ),
            SizedBox(height: 4.h),
            Text(
              indicators[0].label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BatteryLevelIndicator(
              soc: indicators[1].soc,
              color: indicators[1].color,
              isCharging: indicators[1].isCharging,
            ),
            SizedBox(height: 4.h),
            Text(
              indicators[1].label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
        final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 32.r;
        final unit = height / 20.0;
        final double width = 34.0 * unit;
        final clampedLevel = (soc / 100.0).clamp(0.0, 1.0);

        final borderW = 1.5 * unit;
        final borderRadius = 2.0 * unit;
        final terminalW = 2.5 * unit;
        final terminalH = 7.0 * unit;
        final inset = 1.0 * unit;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isCharging ? AppColors.success : AppColors.textPrimary,
                  width: borderW,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: inset,
                    top: inset,
                    bottom: inset,
                    child: Container(
                      width: (width - 2 * inset - borderW) * clampedLevel,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(1.0 * unit),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isCharging)
                            Icon(
                              Icons.bolt_rounded,
                              color: AppColors.textPrimary,
                              size: height * 0.55,
                            ),
                          Text(
                            '$soc%',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: height * (isCharging ? 0.45 : 0.6),
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              height: 1.0,
                            ),
                          ),
                        ],
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
                color: isCharging ? AppColors.success : AppColors.textPrimary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(1.5 * unit),
                  bottomRight: Radius.circular(1.5 * unit),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
