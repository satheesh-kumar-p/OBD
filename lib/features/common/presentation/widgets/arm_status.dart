import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/comp_mode_status/di/mode_info_providers.dart';
import '../../../../shared/comp_mode_status/enums/mode_enum.dart';

class ArmStatus extends ConsumerWidget {
  const ArmStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final armStatus = ref.watch(modeInfoProvider.select((s) => s.asData?.value?.armStatus ?? ArmStatusEnum.unknown));

    final (color, bgColor, IconData? icon) = switch (armStatus) {
      ArmStatusEnum.armed => (
      Colors.redAccent,
      Colors.redAccent.withOpacity(0.1),
      Icons.lock_open_rounded
      ),
      ArmStatusEnum.disarmed => (
      Colors.greenAccent,
      Colors.greenAccent.withOpacity(0.1),
      Icons.lock_rounded
      ),
      ArmStatusEnum.override => (
      Colors.orangeAccent,
      Colors.orangeAccent.withOpacity(0.1),
      Icons.warning_amber_rounded
      ),
      ArmStatusEnum.unknown => (
      Colors.white24,
      Colors.white10,
      null,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.5), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 20.r),
            SizedBox(width: 8.w),
          ],
          Text(
            armStatus.label,
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5.w,
            ),
          ),
        ],
      ),
    );
  }
}
