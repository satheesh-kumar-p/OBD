import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/vcu_status/vcu_status_providers.dart';
import '../../../../shared/vcu_status/domain/vcu_status_enums.dart';

class DriveModeLabel extends ConsumerWidget {
  const DriveModeLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(vcuStatusProvider).asData?.value;

    final driveMode = status?.driveMode ?? DriveModeEnum.unknown;
    final driveLimit = status?.driveModeLimit ?? DriveModeLimitEnum.unknown;

    final mainText = driveMode.label;
    final subText = driveLimit.label;

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
                color: driveMode == DriveModeEnum.unknown ? Colors.white : Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4.w,
                height: 1.1,
              ),
            ),
            Text(
              subText,
              style: TextStyle(
                color: driveLimit == DriveModeLimitEnum.unknown ? Colors.white : Colors.orangeAccent,
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
