import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HudModeLabel extends StatelessWidget {
  const HudModeLabel({
    super.key,
    required this.mainText,
    required this.subText,
    required this.height,
    required this.maxWidth,
    this.armed = false,
  });

  final String mainText;
  final String subText;
  final double height;
  final double maxWidth;
  final bool armed;

  @override
  Widget build(BuildContext context) {
    final borderColor = armed ? Colors.redAccent.withOpacity(0.8) : Colors.white24;
    final bgColor = armed ? Colors.redAccent.withOpacity(0.1) : Colors.white10;

    return IntrinsicWidth(
      child: Container(
        height: height,
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (armed) ...[
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24.r),
              SizedBox(width: 12.w),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    mainText,
                    style: TextStyle(
                      color: armed ? Colors.redAccent : Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4.w,
                      height: 1.1,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    subText,
                    style: TextStyle(
                      color: armed ? Colors.redAccent.withOpacity(0.7) : Colors.cyanAccent,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3.w,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
