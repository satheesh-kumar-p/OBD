import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/vcu_status/domain/vcu_status_enums.dart';
import '../../../../shared/vcu_status/vcu_status_providers.dart';

class SafetyStatus extends ConsumerWidget {
  const SafetyStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vcuStatus = ref.watch(vcuStatusProvider).asData?.value;

    final physicalEStopColor = _getEmergencyColor(vcuStatus?.emergency);
    final isPhysicalEStopInactive = vcuStatus?.emergency == EmergencyEnum.unknown || vcuStatus == null;

    final remoteEStopColor = _getRemoteEmergencyColor(vcuStatus?.remoteEmergency);
    final isRemoteEStopInactive = vcuStatus?.remoteEmergency == RemoteEmergencyEnum.unknown || vcuStatus == null;

    final towStatusColor = _getTowColor(vcuStatus?.towMode);
    final isTowInactive = vcuStatus?.towMode == TowModeEnum.unknown || vcuStatus == null;

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
          icon: Icons.car_crash_outlined,
        ),
      ],
    );
  }

  Color _getEmergencyColor(EmergencyEnum? state) {
    return switch (state) {
      EmergencyEnum.disabled => Colors.orangeAccent,
      EmergencyEnum.disengaged => const Color(0xFF00FF66), // Green
      EmergencyEnum.engaged => const Color(0xFFFF3B3B),    // Red
      _ => Colors.white24,
    };
  }

  Color _getRemoteEmergencyColor(RemoteEmergencyEnum? state) {
    return switch (state) {
      RemoteEmergencyEnum.disengaged => const Color(0xFF00FF66), // Green
      RemoteEmergencyEnum.engaged => const Color(0xFFFF3B3B),    // Red
      _ => Colors.white24,
    };
  }

  Color _getTowColor(TowModeEnum? state) {
    return switch (state) {
      TowModeEnum.disengaged => const Color(0xFF00FF66), // Green
      TowModeEnum.engaged => const Color(0xFFFF3B3B),    // Red
      _ => Colors.white24,
    };
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
