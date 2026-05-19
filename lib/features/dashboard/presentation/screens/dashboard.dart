import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/dashboard/di/dashboard_providers.dart';
import 'package:scout_obd/features/dashboard/presentation/widgets/hud_frame_overlay.dart';
import 'package:scout_obd/features/dashboard/presentation/widgets/hud_sidebar.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';
import 'package:scout_obd/features/drive/presentation/screens/drive_status_screen.dart';

import 'package:scout_obd/features/system/presentation/screens/ugv_system_screen.dart';
import 'package:scout_obd/features/compute/presentation/screens/ugv_compute_screen.dart';
import 'package:scout_obd/features/compute/di/ugv_subsystem_providers.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the combined dashboard state
    final dashboardState = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Content Layer
          _DashboardContent(state: dashboardState),

          // Sidebar Layer
          HudSidebar(
            items: const [
              'SYSTEM', 'DRIVE', 'POWER', 'COMPUTE',
              'SENSOR', 'COM', 'ALERTS', 'PAYLOAD',
            ],
            selectedIndex: dashboardState.selectedIndex,
            onSelect: (index) {
              ref.read(dashboardIndexProvider.notifier).state = index;
              if (index == 3) {
                // Force a fresh request when COMPUTE is clicked
                ref.invalidate(ugvVersionsProvider);
              }
            },
          ),

          // HUD Frame Layer
          HudFrameOverlay(state: dashboardState),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: state.selectedIndex,
      children: const [
        SystemScreen(),
        DriveScreen(),
        _PlaceholderPage(title: 'POWER'),
        ComputeScreen(),
        _PlaceholderPage(title: 'SENSOR'),
        _PlaceholderPage(title: 'COM'),
        _PlaceholderPage(title: 'ALERTS'),
        _PlaceholderPage(title: 'PAYLOAD'),
      ],
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white24,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
    );
  }
}
