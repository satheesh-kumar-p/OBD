import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dashboard_providers.dart';

class HudHandctrlStatus extends ConsumerWidget {
  const HudHandctrlStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = ref.watch(dashboardStateProvider.select((s) => s.handCtrlColor));
    final iconSize = 44.r;

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _HandControllerPainter(color: statusColor),
      ),
    );
  }
}

class _HandControllerPainter extends CustomPainter {
  const _HandControllerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    const designSize = 100.0;
    final scale = math.min(size.width, size.height) / designSize;
    final dx = (size.width - designSize * scale) / 2.0;
    final dy = (size.height - designSize * scale) / 2.0;
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()..fillType = PathFillType.evenOdd;

    // Main vertical body
    const bodyRect = Rect.fromLTWH(25, 10, 50, 80);
    path.addRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(8)));

    // Top Antenna
    const antennaRect = Rect.fromLTWH(47, 2, 6, 8);
    path.addRRect(RRect.fromRectAndRadius(antennaRect, const Radius.circular(2)));

    // Screen area (as a hole)
    const screenRect = Rect.fromLTWH(30, 18, 40, 25);
    path.addRRect(RRect.fromRectAndRadius(screenRect, const Radius.circular(2)));

    // Control area elements (as holes)
    // Left Control (D-pad style)
    path.addOval(Rect.fromCircle(center: const Offset(38, 55), radius: 6));
    
    // Right Control (Action buttons style)
    path.addOval(Rect.fromCircle(center: const Offset(62, 55), radius: 6));

    // Middle/Bottom buttons
    path.addOval(Rect.fromCircle(center: const Offset(50, 55), radius: 3));
    
    const lowerButtonsY = 72.0;
    path.addOval(Rect.fromCircle(center: const Offset(38, lowerButtonsY), radius: 4));
    path.addOval(Rect.fromCircle(center: const Offset(50, lowerButtonsY), radius: 4));
    path.addOval(Rect.fromCircle(center: const Offset(62, lowerButtonsY), radius: 4));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HandControllerPainter oldDelegate) => oldDelegate.color != color;
}
