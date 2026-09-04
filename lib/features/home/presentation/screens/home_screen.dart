import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/sidebar.dart';
import '../../home_providers.dart';
import '../../../communication/communication_screen.dart';
import '../../../power/presentation/screens/power_screen.dart';
import '../../../drive/presentation/screens/drive_screen.dart';
import '../../../debug/presentation/screens/debug_screen.dart';
import '../../../sensor/presentation/screens/sensor_screen.dart';
import '../../../system/presentation/screens/system_screen.dart';
import '../../../common/presentation/screens/common_screen.dart';
import '../../../compute/presentation/screens/compute_screen.dart';
import '../../../checksum/presentation/screens/checksum_status_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(homeIndexProvider);

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
            // 1. Common Page (Top Bar)
            SizedBox(
              height: 60.h,
              child: const CommonScreen(),
            ),

            // 2. Main Area (Sidebar + Content)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sidebar for navigation
                  SizedBox(
                    width: 180.w,
                    child: Sidebar(
                      items: const [
                        'SYSTEM',
                        'DRIVE',
                        'POWER',
                        'COMPUTE',
                        'SENSOR',
                        'COMMS',
                        'DEBUG',
                        'VERSION'
                      ],
                      selectedIndex: selectedIndex,
                      onSelect: (index) {
                        ref.read(homeIndexProvider.notifier).setIndex(index);
                      },
                    ),
                  ),

                  // Page Content (Rendered selected screens)
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: const [
                        SystemScreen(),
                        DriveScreen(),
                        PowerScreen(),
                        ComputeScreen(),
                        SensorScreen(),
                        CommunicationScreen(),
                        DebugScreen(),
                        ChecksumStatusScreen(),
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
