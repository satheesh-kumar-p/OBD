import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HudUptimeLabel extends StatelessWidget {
  const HudUptimeLabel({
    super.key,
    required this.height,
    this.uptime = '00:00:00',
  });

  final double height;
  final String uptime;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        'UP TIME : $uptime',
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
