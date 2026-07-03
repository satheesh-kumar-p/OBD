import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dashboard_providers.dart';

class HudSafetyStatus extends ConsumerWidget {
  const HudSafetyStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final physicalEStopColor = ref.watch(dashboardStateProvider.select((s) => s.physicalEStopColor));
    final isPhysicalEStopInactive = ref.watch(dashboardStateProvider.select((s) => s.isPhysicalEStopInactive));
    
    final remoteEStopColor = ref.watch(dashboardStateProvider.select((s) => s.remoteEStopColor));
    final isRemoteEStopInactive = ref.watch(dashboardStateProvider.select((s) => s.isRemoteEStopInactive));
    
    final towStatusColor = ref.watch(dashboardStateProvider.select((s) => s.towStatusColor));
    final isTowInactive = ref.watch(dashboardStateProvider.select((s) => s.isTowInactive));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SafetyIndicator(
          label: 'E-STOP',
          color: physicalEStopColor,
          isInactive: isPhysicalEStopInactive,
          icon: Icons.stop_circle_rounded,
        ),
        SizedBox(width: 8.w),
        _SafetyIndicator(
          label: 'REMOTE\nE-STOP',
          color: remoteEStopColor,
          isInactive: isRemoteEStopInactive,
          icon: Icons.settings_remote_rounded,
        ),
        SizedBox(width: 8.w),
        _SafetyIndicator(
          label: 'TOW',
          color: towStatusColor,
          isInactive: isTowInactive,
          icon: Icons.airport_shuttle_rounded,
        ),
      ],
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
    final borderColor = isInactive ? Colors.white10 : color.withOpacity(0.8);
    final bgColor = isInactive ? Colors.white.withOpacity(0.05) : color.withOpacity(0.15);

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
            color: isInactive ? Colors.white24 : color,
            size: 20.r,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isInactive ? Colors.white24 : color,
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
