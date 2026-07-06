import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';

class GcsStatus extends ConsumerWidget {
  const GcsStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsystemState = ref.watch(compSubsystemInfoProvider).asData?.value;
    final status = subsystemState?.lBandRadio;
    
    final statusColor = switch (status) {
      SubsystemFaultState.noFault => const Color(0xFF00FF66),
      SubsystemFaultState.faulty => const Color(0xFFFF3B3B),
      SubsystemFaultState.unknown || null => Colors.white,
    };

    final iconSize = 44.r;

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _GcsPainter(color: statusColor),
      ),
    );
  }
}

class _GcsPainter extends CustomPainter {
  const _GcsPainter({required this.color});

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

    const bodyRect = Rect.fromLTWH(10, 30, 80, 54);
    path.addRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(16)));

    const leftGrip = Rect.fromLTWH(2, 34, 22, 48);
    const rightGrip = Rect.fromLTWH(76, 34, 22, 48);
    path.addRRect(RRect.fromRectAndRadius(leftGrip, const Radius.circular(14)));
    path.addRRect(RRect.fromRectAndRadius(rightGrip, const Radius.circular(14)));

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

    const screenHole = Rect.fromLTWH(32, 40, 36, 22);
    path.addRRect(RRect.fromRectAndRadius(screenHole, const Radius.circular(4)));

    const buttonR = 3.0;
    const leftButtonsX = 16.0;
    const rightButtonsX = 84.0;
    const buttonYs = <double>[44.0, 54.0, 64.0];
    for (final y in buttonYs) {
      path.addOval(Rect.fromCircle(center: const Offset(leftButtonsX, 0).translate(0, y), radius: buttonR));
      path.addOval(Rect.fromCircle(center: const Offset(rightButtonsX, 0).translate(0, y), radius: buttonR));
    }

    const indicatorY = 35.0;
    path.addOval(Rect.fromCircle(center: const Offset(46, indicatorY), radius: 1.6));
    path.addOval(Rect.fromCircle(center: const Offset(50, indicatorY), radius: 1.6));
    path.addOval(Rect.fromCircle(center: const Offset(54, indicatorY), radius: 1.6));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GcsPainter oldDelegate) => oldDelegate.color != color;
}
