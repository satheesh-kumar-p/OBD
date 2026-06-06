import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/dashboard/di/dashboard_providers.dart';
import 'package:scout_obd/features/dashboard/presentation/widgets/hud_frame_overlay.dart';

class HudWrapper extends ConsumerWidget {
  const HudWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardStateProvider);
    
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              colors: [Color(0xFF0A1929), Color(0xFF112240)],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        // HUD frame
        Positioned.fill(
          child: HudFrameOverlay(state: state),
        ),
        child,
      ],
    );
  }
}
