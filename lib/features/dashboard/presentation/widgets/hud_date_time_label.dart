import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HudDateTimeLabel extends StatelessWidget {
  const HudDateTimeLabel({super.key, required this.height, required this.systemTime});

  final double height;
  final String systemTime;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        systemTime,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6.w,
          height: 1,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}