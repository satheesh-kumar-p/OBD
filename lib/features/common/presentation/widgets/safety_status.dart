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
            isInactive: indicator.isInactive,
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
  final bool isInactive;

  const _SafetyIndicator({
    required this.label,
    required this.color,
    required this.icon,
    required this.isInactive,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isInactive ? AppColors.border : color.withOpacity(0.8);
    final bgColor = isInactive ? AppColors.surface : color.withOpacity(0.15);

    return Container(
      width: 58.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: borderColor, width: 1.w),
        boxShadow: !isInactive ? [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8.r,
            spreadRadius: 1.r,
          )
        ] : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isInactive ? AppColors.textDisabled : color,
            size: 20.r,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isInactive ? AppColors.textDisabled : color,
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
