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
      children: indicators.map((indicator) {
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: _SafetyIndicator(
            label: indicator.label,
            color: indicator.color,
            icon: indicator.icon,
          ),
        );
      }).toList(),
    );
  }
}

class _SafetyIndicator extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _SafetyIndicator({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 20.r,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 9.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
