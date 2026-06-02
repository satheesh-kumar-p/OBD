import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scout_obd/features/dashboard/di/dashboard_providers.dart';
import 'package:scout_obd/features/dashboard/presentation/widgets/hud_sidebar.dart';
import 'package:scout_obd/features/dashboard/presentation/widgets/hud_top_bar.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';
import 'package:scout_obd/features/drive/presentation/screens/drive_status_screen.dart';
import 'package:scout_obd/features/debug/presentation/screens/debug_screen.dart';

import 'package:scout_obd/features/system/presentation/screens/system_screen.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardStateProvider);

    final topBarHeight = 80.h;
    final sidebarWidth = 180.w;
    final horizontalMargin = 20.w;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Status Bar
            HudTopBar(
              state: dashboardState,
              height: topBarHeight,
              horizontalPadding: horizontalMargin,
            ),

            // 2. Main Area (Sidebar + Content)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sidebar
                  HudSidebar(
                    items: const [
                      'SYSTEM', 'DRIVE', 'DEBUG',
                    ],
                    selectedIndex: dashboardState.selectedIndex,
                    width: sidebarWidth,
                    onSelect: (index) {
                      ref.read(dashboardIndexProvider.notifier).state = index;
                    },
                  ),

                  // Page Content
                  Expanded(
                    child: _DashboardContent(state: dashboardState),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        DebugScreen(),
      ],
    );
  }
}
