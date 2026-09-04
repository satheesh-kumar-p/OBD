import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../common_providers.dart';

class MissionModeLabel extends ConsumerWidget {
  const MissionModeLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (mainText, subText, subColor) = ref.watch(commonScreenStateProvider.select((s) => s.missionModeVisuals));

    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border, width: 1.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mainText,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.w,
                  height: 1.0,
                ),
              ),
              Text(
                subText,
                style: TextStyle(
                  color: subColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.w,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}