import 'dart:math' as math;

import 'package:flutter/material.dart';

class HudHandctrlStatus extends StatelessWidget {
  const HudHandctrlStatus({
    super.key,
    required this.height,
    required this.color,
    this.size,
    this.gapAfter = 12.0,
  });

  final double height;

  /// Icon tint color.
  final Color color;

  /// Icon size (square). If null, derived from [height].
  final double? size;

  final double gapAfter;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? (height * 0.55).clamp(14.0, 32.0).toDouble();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: HandControllerIcon(color: color),
        ),
        SizedBox(width: gapAfter),
      ],
    );
  }
}

class HandControllerIcon extends StatelessWidget {
  const HandControllerIcon({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HandControllerPainter(color: color),
    );
  }
}

class _HandControllerPainter extends CustomPainter {
  const _HandControllerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Design in a 100x100 coordinate system, then scale to fit.
    const designSize = 100.0;
    final scale = math.min(size.width, size.height) / designSize;
    final dx = (size.width - designSize * scale) / 2.0;
    final dy = (size.height - designSize * scale) / 2.0;
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    // Controller cutout silhouette:
    // - Filled body/antennas
    // - Screen + buttons are holes (even-odd fill)
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()..fillType = PathFillType.evenOdd;

    // Outer body.
    const bodyRect = Rect.fromLTWH(10, 30, 80, 54);
    path.addRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(16)));

    // Side grips (slight protrusion).
    const leftGrip = Rect.fromLTWH(2, 34, 22, 48);
    const rightGrip = Rect.fromLTWH(76, 34, 22, 48);
    path.addRRect(RRect.fromRectAndRadius(leftGrip, const Radius.circular(14)));
    path.addRRect(RRect.fromRectAndRadius(rightGrip, const Radius.circular(14)));

    // Antennas.
    const antennaW = 6.0;
    const antennaH = 18.0;
    const antennaY = 12.0;
    const leftAntennaX = 24.0;
    const rightAntennaX = 70.0;
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(leftAntennaX, antennaY, antennaW, antennaH),
        const Radius.circular(3),
      ),
    );
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rightAntennaX, antennaY, antennaW, antennaH),
        const Radius.circular(3),
      ),
    );

    // Screen hole (center).
    const screenRect = Rect.fromLTWH(32, 40, 36, 22);
    path.addRRect(RRect.fromRectAndRadius(screenRect, const Radius.circular(4)));

    // Side button holes.
    const buttonR = 3.0;
    const leftButtonsX = 16.0;
    const rightButtonsX = 84.0;
    const buttonYs = <double>[44.0, 54.0, 64.0];
    for (final y in buttonYs) {
      path.addOval(Rect.fromCircle(center: const Offset(leftButtonsX, 0).translate(0, y), radius: buttonR));
      path.addOval(Rect.fromCircle(center: const Offset(rightButtonsX, 0).translate(0, y), radius: buttonR));
    }

    // Small top indicators (holes) above the screen.
    const indicatorY = 35.0;
    path.addOval(Rect.fromCircle(center: const Offset(46, indicatorY), radius: 1.6));
    path.addOval(Rect.fromCircle(center: const Offset(50, indicatorY), radius: 1.6));
    path.addOval(Rect.fromCircle(center: const Offset(54, indicatorY), radius: 1.6));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HandControllerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}