import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../debug/presentation/screens/debug_screen.dart';
import '../../../drive/presentation/screens/drive_status_screen.dart';
import '../../../system/presentation/screens/system_screen.dart';
import '../../di/dashboard_providers.dart';
import '../../state/dashboard_state.dart';
import '../widgets/hud_sidebar.dart';
import '../widgets/hud_top_bar.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 60.h,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: const HudTopBar(),
            ),

            // 2. Main Area (Sidebar + Content)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 180.w,
                    child: HudSidebar(
                      items: const [
                        'SYSTEM', 'DRIVE', 'DEBUG',
                      ],
                      selectedIndex: dashboardState.selectedIndex,
                      onSelect: (index) {
                        ref.read(dashboardIndexProvider.notifier).state = index;
                      },
                    ),
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
