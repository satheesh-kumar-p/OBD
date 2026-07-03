import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../debug/presentation/screens/debug_screen.dart';
import '../../../drive/presentation/screens/drive_status_screen.dart';
import '../../../system/presentation/screens/system_screen.dart';
import '../../dashboard_providers.dart';
import '../widgets/hud_sidebar.dart';
import '../widgets/hud_top_bar.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dashboardStateProvider.select((s) => s.selectedIndex));

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
                      selectedIndex: selectedIndex,
                      onSelect: (index) {
                        ref.read(dashboardIndexProvider.notifier).state = index;
                      },
                    ),
                  ),

                  // Page Content
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: const [
                        SystemScreen(),
                        DriveScreen(),
                        DebugScreen(),
                      ],
                    ),
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
