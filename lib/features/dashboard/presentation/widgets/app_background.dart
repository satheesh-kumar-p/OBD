import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/dashboard/di/dashboard_providers.dart';

import 'hud_frame_overlay.dart';

class AppBackground extends ConsumerWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardStateProvider);
    
    return Stack(
      children: [
        // Solid black background for the HUD
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
        
        // HUD frame overlay
        Positioned.fill(
          child: HudFrameOverlay(
            state: state,
            drawLeftSlots: false,
          ),
        ),
        child,
      ],
    );
  }
}
