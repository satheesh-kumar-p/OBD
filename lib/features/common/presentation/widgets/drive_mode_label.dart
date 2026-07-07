import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../common_providers.dart';

class DriveModeLabel extends ConsumerWidget {
  const DriveModeLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (mainText, subText, subColor) = ref.watch(commonScreenStateProvider.select((s) => s.driveModeVisuals));

    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border, width: 1.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mainText,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4.w,
                height: 1.1,
              ),
            ),
            Text(
              subText,
              style: TextStyle(
                color: subColor,
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
