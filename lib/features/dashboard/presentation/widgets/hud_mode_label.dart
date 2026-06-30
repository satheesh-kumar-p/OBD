import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HudModeLabel extends StatelessWidget {
  const HudModeLabel({
    super.key,
    required this.mainText,
    required this.subText,
  });

  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.white24;
    const bgColor = Colors.white10;

    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mainText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4.w,
                height: 1.1,
              ),
            ),
            Text(
              subText,
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3.w,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
