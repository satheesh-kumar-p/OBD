import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common_providers.dart';

class ArmStatus extends ConsumerWidget {
  const ArmStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = {lable: "ARMED", color: Colors.red, bgColor: Colors.red.withOpacity(0.1)};
    final state = ref.watch(commonScreenStateProvider.select((s) => s.armStatus));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: state.bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: state.color.withOpacity(0.5), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // if (state.icon != null) ...[
          //   Icon(state.icon, color: state.color, size: 20.r),
          //   SizedBox(width: 8.w),
          // ],
          Text(
            state.label,
            style: TextStyle(
              color: state.color,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.w,
            ),
          ),
        ],
      ),
    );
  }
}
