import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/comp_mode_status/di/mode_info_providers.dart';

class MissionModeLabel extends ConsumerWidget {
  const MissionModeLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeInfoProvider).asData?.value;
    final mainText = mode?.mainMode.label ?? 'UNKNOWN';
    final subText = 'HOLD: ${mode?.holdSubMode.label ?? 'UNKNOWN'}';

    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white24, width: 1.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mainText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4.w,
                height: 1.1,
              ),
            ),
            Text(
              subText,
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3.w,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
