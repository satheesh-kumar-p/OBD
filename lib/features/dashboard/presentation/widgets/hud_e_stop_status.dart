import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../di/dashboard_providers.dart';
import '../../../../shared/vcu_estop_status/enums/e_stop_status_enum.dart';

class HudEStopStatus extends ConsumerWidget {
  const HudEStopStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(dashboardStateProvider.select((s) => s.eStopInfo?.status));
    final color = ref.watch(dashboardStateProvider.select((s) => s.eStopColor));
    
    final isEngaged = status == EStopStatus.engaged;
    final textColor = isEngaged ? Colors.white : Colors.white.withOpacity(0.6);

    final size = 44.r;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isEngaged ? color : color.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: isEngaged ? color : color.withOpacity(0.2),
          width: 1.5.r,
        ),
      ),
      child: Center(
        child: Text(
          'STOP',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
