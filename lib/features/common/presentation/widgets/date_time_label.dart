import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common_providers.dart';

class DateTimeLabel extends ConsumerWidget {
  const DateTimeLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemTime = ref.watch(systemTimeProvider);

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
