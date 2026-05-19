import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/features/system/di/ugv_health_providers.dart';
import 'package:scout_obd/features/system/enums/subsystem_status_enum.dart';
import 'hud_date_time_label.dart';
import 'hud_battery_status_icon.dart';
import 'hud_link_status_icon.dart';
import 'hud_mode_label.dart';
import 'hud_uptime_label.dart';
import 'hud_handctrlStatus.dart';

class HudFrameOverlay extends ConsumerWidget {
  const HudFrameOverlay({
    super.key,
    required this.state,
    this.drawLeftSlots = true,
  });

  final DashboardState state;
  final bool drawLeftSlots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ugvHealth = ref.watch(ugvHealthDataProvider(AppConstants.primaryLinkId)).asData?.value;

    const subsystemKeyForHud = 'UHF Radio';
    final status = ugvHealth?.subsystemHealthMap[subsystemKeyForHud];

    final bool? isHandCtrlHealthy = status == null? null: status == SubsystemStatus.healthy;

    final String handCtrlStatusText = switch (status) {
      null => '---',
      SubsystemStatus.healthy => 'HEALTHY',
      SubsystemStatus.unhealthy => 'UNHEALTHY',
      SubsystemStatus.noCommunication => 'NO COMMUNICATION',
    };

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          if (w <= 0 || h <= 0) {
            return const SizedBox.shrink();
          }

          final s = math.min(w, h);
          // Reduced margins and padding for small 5" screen
          final m = s * 0.015; 
          final inset = s * 0.005;

          final rect = Rect.fromLTWH(
            m + inset,
            m + inset,
            w - 2 * (m + inset),
            h - 2 * (m + inset),
          );
          final thin = (s * 0.002).clamp(1.0, 2.0).toDouble();
          final innerInset = s * 0.015;
          final innerTop = rect.top + innerInset;

          final topY = innerTop;
          final labelH = (s * 0.09).clamp(28.0, 70.0).toDouble();

          final left = rect.left + innerInset;
          final maxWidth = rect.width * 0.45;

          return Stack(
            children: [
              RepaintBoundary(
                child: CustomPaint(
                  painter: _HudFramePainter(
                    labelTop: topY,
                    labelHeight: labelH,
                    labelLeft: left,
                    labelMaxWidth: maxWidth,
                    drawLeftSlots: drawLeftSlots,
                    margin: m,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                left: left,
                top: topY,
                child: SizedBox(
                  width: rect.right - rect.width * 0.04 - left,
                  height: labelH,
                  child: Row(
                    children: [
                      HudModeLabel(
                        mainText: state.modeName,
                        subText: state.subModeName,
                        height: labelH,
                        maxWidth: maxWidth,
                      ),
                      SizedBox(width: (labelH * 0.15).clamp(4.0, 12.0)),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, innerConstraints) {
                                  final availableW = innerConstraints.maxWidth;
                                  final desiredGap = (labelH * 0.4).clamp(8.0, 40.0);
                                  final minGap = 4.0;
                                  final adaptiveGap = math.min(
                                    desiredGap,
                                    math.max(minGap, availableW * 0.04),
                                  );

                                  return Row(
                                    children: [
                                      Flexible(
                                        child: HudUptimeLabel(
                                          height: labelH,
                                          uptime: state.uptimeFormatted,
                                        ),
                                      ),
                                      SizedBox(width: adaptiveGap),
                                      Flexible(
                                        child: HudDateTimeLabel(
                                          height: labelH,
                                          systemTime: state.systemTimeFormatted,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: (labelH * 0.15).clamp(4.0, 12.0)),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    HudHandctrlStatus(
                                      height: labelH,
                                      statusText: handCtrlStatusText,
                                      isHealthy: isHandCtrlHealthy,
                                      gapAfter: (labelH * 0.12)
                                          .clamp(4.0, 12.0)
                                          .toDouble(),
                                    ),
                                    HudLinkStatusIcon(
                                      size: labelH * 0.65,
                                      healthLevel: state.healthLevel,
                                    ),
                                    SizedBox(
                                      width: (labelH * 0.12).clamp(4.0, 12.0),
                                    ),
                                    HudBatteryStatusIcon(
                                      size: labelH * 0.55,
                                      percentage: state.batteryLevel,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HudFramePainter extends CustomPainter {
  const _HudFramePainter({
    required this.labelTop,
    required this.labelHeight,
    required this.labelLeft,
    required this.labelMaxWidth,
    required this.drawLeftSlots,
    required this.margin,
  });

  final double labelTop;
  final double labelHeight;
  final double labelLeft;
  final double labelMaxWidth;
  final bool drawLeftSlots;
  final double margin;

  static const _cyan = Color(0xFF2FD0FF);
  static const _cyanSoft = Color(0xFF8BE9FF);
  static const _steel = Color(0xFF93A9B5);

  static Color _a(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    final s = math.min(w, h);
    final m = margin;
    final r = s * 0.02;
    final thin = (s * 0.002).clamp(1.0, 2.0).toDouble();
    final mid = (s * 0.003).clamp(1.0, 3.0).toDouble();
    final glow = (s * 0.006).clamp(4.0, 10.0).toDouble();

    final outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(m, m, w - 2 * m, h - 2 * m),
      Radius.circular(r),
    );

    final outer2 = outer.deflate(s * 0.005);
    final inner = outer2.deflate(s * 0.015);

    _strokeRRect(canvas, outer, strokeWidth: thin, color: _a(_steel, 0.3));

    _glowRRect(
      canvas,
      outer2,
      strokeWidth: mid,
      glowWidth: glow,
      shaderRect: outer2.outerRect,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_a(_cyanSoft, 0.2), _a(_cyan, 0.8), _a(_cyanSoft, 0.15)],
      ),
    );

    _strokeRRect(canvas, inner, strokeWidth: thin, color: _a(_steel, 0.2));

    _topHeader(canvas, outer2, thin, mid, glow);
    _sideAccents(canvas, outer2, thin, mid, glow);
    _leftSidebarDivider(canvas, outer2, thin, mid, glow);
    if (drawLeftSlots) {
      _leftSlots(canvas, outer2, thin, mid, glow);
    }
    _bottomNotch(canvas, outer2, thin, mid, glow);
  }

  void _leftSidebarDivider(
    Canvas canvas,
    RRect frame,
    double thin,
    double mid,
    double glow,
  ) {
    final rect = frame.outerRect;

    final panelLeft = rect.left + rect.width * 0.025;
    final panelTop = rect.top + rect.height * 0.12;
    final panelH = rect.height * 0.83;

    final desiredSlotCount = 8;
    final gap = math.max(panelH * 0.02, 4.0);
    const minSlotH = 14.0;

    final maxCount = ((panelH - gap) / (minSlotH + gap)).floor();
    final slotCount = math.max(1, math.min(desiredSlotCount, maxCount));
    final slotH = math.max(0.0, (panelH - gap * (slotCount + 1)) / slotCount);

    final horizontalPad = (slotH * 0.3).clamp(6.0, 16.0).toDouble();

    final maxSlotW = rect.width * 0.16;
    final minSlotW = math.min(70.0, maxSlotW);
    final targetSlotW = (rect.width * 0.12)
        .clamp(minSlotW, maxSlotW)
        .toDouble();

    final maxPanelW = rect.width * 0.2;
    final minPanelW = math.min(90.0, maxPanelW);
    final panelW = (targetSlotW + 2 * horizontalPad)
        .clamp(minPanelW, maxPanelW)
        .toDouble();

    final panelRect = Rect.fromLTWH(panelLeft, panelTop, panelW, panelH);

    final lineX = panelRect.right + rect.width * 0.01;
    final lineW = thin;

    final extend = rect.height * 0.03;
    final yTop = math.max(rect.top + rect.height * 0.08, panelTop - extend);
    final yBottom = math.min(
      rect.bottom - rect.height * 0.04,
      panelTop + panelH + extend,
    );
    final lineRect = Rect.fromLTWH(
      lineX,
      yTop,
      lineW,
      math.max(0.0, yBottom - yTop),
    );

    _glowRect(
      canvas,
      lineRect,
      glowWidth: glow,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _a(_cyan, 0.0),
          _a(_cyan, 0.5),
          _a(_cyanSoft, 0.2),
          _a(_cyan, 0.0),
        ],
        stops: const [0.0, 0.2, 0.8, 1.0],
      ),
    );
  }

  void _topHeader(
    Canvas canvas,
    RRect frame,
    double thin,
    double mid,
    double glow,
  ) {
    final rect = frame.outerRect;
    final y = labelTop + labelHeight;

    final startX = rect.left + rect.width * 0.04;
    final endX = rect.right - rect.width * 0.04;
    final width = math.max(0.0, endX - startX);

    final lineRect = Rect.fromLTWH(startX, y, width, thin);

    _glowRect(
      canvas,
      lineRect,
      glowWidth: glow,
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          _a(_cyan, 0.0),
          _a(_cyan, 0.5),
          _a(_cyanSoft, 0.2),
          _a(_cyan, 0.0),
        ],
        stops: const [0.0, 0.15, 0.75, 1.0],
      ),
    );
  }

  void _sideAccents(
    Canvas canvas,
    RRect frame,
    double thin,
    double mid,
    double glow,
  ) {
    final rect = frame.outerRect;
    final barW = math.max(1.5, rect.width * 0.005);
    final inset = rect.width * 0.005;
    final top = rect.top + rect.height * 0.15;
    final bottom = rect.bottom - rect.height * 0.1;

    final leftBar = Rect.fromLTWH(rect.left + inset, top, barW, bottom - top);
    final rightBar = Rect.fromLTWH(
      rect.right - inset - barW,
      top,
      barW,
      bottom - top,
    );

    _glowRect(
      canvas,
      leftBar,
      glowWidth: glow,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_a(_cyan, 0.1), _a(_cyan, 0.7), _a(_cyan, 0.1)],
      ),
    );

    _glowRect(
      canvas,
      rightBar,
      glowWidth: glow,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_a(_cyan, 0.1), _a(_cyan, 0.7), _a(_cyan, 0.1)],
      ),
    );
  }

  void _leftSlots(
    Canvas canvas,
    RRect frame,
    double thin,
    double mid,
    double glow,
  ) {
    final rect = frame.outerRect;

    final panelLeft = rect.left + rect.width * 0.025;
    final panelTop = rect.top + rect.height * 0.12;
    final panelH = rect.height * 0.83;

    final desiredSlotCount = 8;
    final gap = math.max(panelH * 0.02, 4.0);
    const minSlotH = 14.0;

    final maxCount = ((panelH - gap) / (minSlotH + gap)).floor();
    final slotCount = math.max(1, math.min(desiredSlotCount, maxCount));
    final slotH = math.max(0.0, (panelH - gap * (slotCount + 1)) / slotCount);

    final horizontalPad = (slotH * 0.3).clamp(6.0, 16.0).toDouble();

    final maxSlotW = rect.width * 0.16;
    final minSlotW = math.min(70.0, maxSlotW);
    final targetSlotW = (rect.width * 0.12)
        .clamp(minSlotW, maxSlotW)
        .toDouble();

    final maxPanelW = rect.width * 0.2;
    final minPanelW = math.min(90.0, maxPanelW);
    final panelW = (targetSlotW + 2 * horizontalPad)
        .clamp(minPanelW, maxPanelW)
        .toDouble();

    final slotW = math.max(0.0, panelW - 2 * horizontalPad);
    final slotX = panelLeft + (panelW - slotW) / 2;

    final panel = RRect.fromRectAndRadius(
      Rect.fromLTWH(panelLeft, panelTop, panelW, panelH),
      Radius.circular(rect.width * 0.01),
    );

    _strokeRRect(canvas, panel, strokeWidth: thin, color: _a(_steel, 0.2));

    final slotMid = math.max(thin, math.min(mid, slotH * 0.2));
    final slotGlow = math.min(glow, math.max(2.0, slotH * 0.7));

    for (var i = 0; i < slotCount; i++) {
      final y = panel.outerRect.top + gap + i * (slotH + gap);
      final slot = RRect.fromRectAndRadius(
        Rect.fromLTWH(slotX, y, slotW, slotH),
        Radius.circular(slotH * 0.15),
      );

      _glowRRect(
        canvas,
        slot,
        strokeWidth: slotMid,
        glowWidth: slotGlow,
        shaderRect: slot.outerRect,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_a(_cyan, 0.6), _a(_cyanSoft, 0.15), _a(_cyan, 0.6)],
        ),
      );
    }
  }

  void _bottomNotch(
    Canvas canvas,
    RRect frame,
    double thin,
    double mid,
    double glow,
  ) {
    final rect = frame.outerRect;
    final s = math.min(rect.width, rect.height);

    final notchW = rect.width * 0.18;
    final notchH = rect.height * 0.025;
    final x0 = rect.center.dx - notchW / 2;
    final y0 = rect.bottom - rect.height * 0.03;
    final cut = s * 0.015;

    final p = Path()
      ..moveTo(x0, y0)
      ..lineTo(x0 + notchW * 0.25, y0)
      ..lineTo(x0 + notchW * 0.25 + cut, y0 - notchH)
      ..lineTo(x0 + notchW * 0.75 - cut, y0 - notchH)
      ..lineTo(x0 + notchW * 0.75, y0)
      ..lineTo(x0 + notchW, y0)
      ..close();

    _glowPath(
      canvas,
      p,
      strokeWidth: mid,
      glowWidth: glow,
      shaderRect: rect,
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          _a(_cyan, 0.0),
          _a(_cyan, 0.75),
          _a(_cyanSoft, 0.2),
          _a(_cyan, 0.0),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ),
    );

    final base1 = Rect.fromLTWH(
      rect.left + rect.width * 0.04,
      rect.bottom - rect.height * 0.045,
      rect.width * 0.92,
      thin,
    );

    _glowRect(
      canvas,
      base1,
      glowWidth: glow,
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [_a(_cyan, 0.0), _a(_cyan, 0.3), _a(_cyan, 0.0)],
      ),
    );
  }

  void _strokeRRect(
    Canvas canvas,
    RRect rrect, {
    required double strokeWidth,
    required Color color,
  }) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color
      ..isAntiAlias = true;
    canvas.drawRRect(rrect, paint);
  }

  void _glowRRect(
    Canvas canvas,
    RRect rrect, {
    required double strokeWidth,
    required double glowWidth,
    required Rect shaderRect,
    required Gradient gradient,
  }) {
    final shader = gradient.createShader(shaderRect);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowWidth)
      ..isAntiAlias = true;

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader
      ..isAntiAlias = true;

    canvas.drawRRect(rrect, glowPaint);
    canvas.drawRRect(rrect, corePaint);
  }

  void _glowRect(
    Canvas canvas,
    Rect rect, {
    required double glowWidth,
    required Gradient gradient,
  }) {
    final shader = gradient.createShader(rect);

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = shader
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowWidth)
      ..isAntiAlias = true;

    final corePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = shader
      ..isAntiAlias = true;

    canvas.drawRect(rect, glowPaint);
    canvas.drawRect(rect, corePaint);
  }

  void _glowPath(
    Canvas canvas,
    Path path, {
    required double strokeWidth,
    required double glowWidth,
    required Rect shaderRect,
    required Gradient gradient,
  }) {
    final shader = gradient.createShader(shaderRect);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowWidth)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = shader
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _HudFramePainter) return true;
    return oldDelegate.labelTop != labelTop ||
        oldDelegate.labelHeight != labelHeight ||
        oldDelegate.labelLeft != labelLeft ||
        oldDelegate.labelMaxWidth != labelMaxWidth ||
        oldDelegate.margin != margin;
  }
}
