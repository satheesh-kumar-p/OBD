import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/vcu_status/vcu_status_providers.dart';
import '../../../../shared/vcu_status/domain/vcu_status_enums.dart';

class ArmStatus extends ConsumerWidget {
  const ArmStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final armMode = ref.watch(vcuStatusProvider.select((s) => s.asData?.value?.armMode ?? ArmModeEnum.unknown));

    final (color, bgColor, IconData? icon) = switch (armMode) {
      ArmModeEnum.armed => (
        const Color(0xFFFF3B3B), // Red
        const Color(0xFFFF3B3B).withOpacity(0.1),
        Icons.lock_open_rounded
      ),
      ArmModeEnum.disarmed => (
        const Color(0xFF00FF66), // Green
        const Color(0xFF00FF66).withOpacity(0.1),
        Icons.lock_rounded
      ),
      ArmModeEnum.override => (
        Colors.orangeAccent,
        Colors.orangeAccent.withOpacity(0.1),
        Icons.warning_amber_rounded
      ),
      _ => (
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
            armMode.label,
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
