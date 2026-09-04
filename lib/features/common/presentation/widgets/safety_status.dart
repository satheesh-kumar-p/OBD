import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../common_providers.dart';

class SafetyStatus extends ConsumerWidget {
  const SafetyStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicators = ref.watch(commonScreenStateProvider.select((s) => s.safetyIndicators));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center, // Aligns all indicators nicely
      children: indicators.map((indicator) {
        return Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: _SafetyIndicator(
            // label: indicator.label,
            color: indicator.color,
            icon: indicator.icon,
          ),
        );
      }).toList(),
    );
  }
}

class _SafetyIndicator extends StatelessWidget {
  // final String label;
  final Color color;
  final IconData icon;

  const _SafetyIndicator({
    // required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: 60.r,
    );

    /* 
    return Container(
      width: 100.w,
      height: 40.h, // Explicit height guarantees equal height across all items
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.6), width: 1.5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          Icon(
            icon,
            color: color,
            size: 24.r,
          ),
          SizedBox(height: 3.h),
          // Text(
          //   // label,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: color,
          //     fontSize: 18.sp,
          //     fontWeight: FontWeight.w900,
          //     height: 1,
          //     letterSpacing: 0.5,
          //   ),
          // ),
        ],
      ),
    );
    */
  }
}