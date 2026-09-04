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
    // const bool charging = true;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 25.w,
          height: 40.h,
          child: _BatteryLevelIndicator(
            soc: state.soc,
            color: state.color,
          ),
        ),
        if (state.isCharging) ...[
          // if(charging) ...[
          SizedBox(width: 1.w),
Transform.scale(
            scaleY: 3.3, 
            scaleX: 2, 
            child: Icon(
              Icons.bolt_rounded,
              color: state.color,
              size: 18.r,
            ),),
        ],
        SizedBox(width: 5.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${state.soc}',
              style: TextStyle(
                // color: state.color,
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
                height: 1,
              ),
            ),
            Text(
              state.label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                height: 1.0,
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

  const _BatteryLevelIndicator({
    required this.soc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final totalHeight = constraints.maxHeight;
        final unit = width / 14.0;

        final terminalH = 2.5 * unit;
        final terminalW = 7.0 * unit;
        final bodyHeight = totalHeight - terminalH;
        final clampedLevel = (soc / 100.0).clamp(0.0, 1.0);

        final borderW = 1.2 * unit;
        final borderRadius = 3.0 * unit;
        final inset = 2.0 * unit;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: terminalW,
              height: terminalH,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2.0 * unit),
                  topRight: Radius.circular(2.0 * unit),
                ),
              ),
            ),
            Container(
              width: width,
              height: bodyHeight,
              decoration: BoxDecoration(
                color: AppColors.batteryEmpty,
                border: Border.all(color: color, width: borderW),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    left: inset,
                    right: inset,
                    bottom: inset,
                    child: Container(
                      height: (bodyHeight - 2 * inset - borderW) * clampedLevel,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(1.5 * unit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}