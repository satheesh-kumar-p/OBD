import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../common_providers.dart';

class DateTimeLabel extends ConsumerWidget {
  const DateTimeLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemTime = ref.watch(
      commonScreenStateProvider.select((s) => s.systemTime),
    );

    final spaceIndex = systemTime.indexOf(' ');
    final datePart = spaceIndex != -1
        ? systemTime.substring(0, spaceIndex)
        : systemTime;

    final timePart = spaceIndex != -1
        ? systemTime.substring(spaceIndex + 1)
        : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
                Text(
          datePart,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 4.w,
            height: 0.8,
            fontFamily: 'monospace',
            decoration: TextDecoration.none,
          ),
        ),
        Text(
          timePart,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 35.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 4.w,
            height: 0.5, // IMPORTANT
            fontFamily: 'monospace',
            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: 6.h),


      ],
    );
  }
}