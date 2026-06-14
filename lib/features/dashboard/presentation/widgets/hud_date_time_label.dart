import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../di/dashboard_providers.dart';

class HudDateTimeLabel extends ConsumerWidget {
  const HudDateTimeLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemTime = ref.watch(dashboardStateProvider.select((s) => s.systemTimeFormatted));

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Text(
        systemTime,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2.w,
          height: 1,
          fontFamily: 'monospace',
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
