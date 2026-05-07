import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/features/common_page/di/common_page_providers.dart';
import 'package:scout_obd/features/common_page/presentation/widgets/hud_frame_overlay.dart';
import 'package:scout_obd/features/common_page/presentation/widgets/hud_sidebar.dart';
import 'package:scout_obd/features/common_page/state/common_page_state.dart';

class CommonPage extends ConsumerWidget {
  const CommonPage({super.key});

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
        _PlaceholderPage(title: 'SYSTEM'),
        _PlaceholderPage(title: 'DRIVE'),
        _PlaceholderPage(title: 'POWER'),
        _PlaceholderPage(title: 'COMPUTE'),
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
