import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'hud_mode_label.dart';
import 'hud_arm_status.dart';
import 'hud_gcs_status.dart';
import 'hud_safety_status.dart';
import 'hud_handctrlStatus.dart';
import 'hud_date_time_label.dart';
import 'hud_battery_status_icon.dart';
import '../../dashboard_providers.dart';

class HudTopBar extends ConsumerWidget {
  const HudTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeName = ref.watch(dashboardStateProvider.select((s) => s.modeName));
    final holdMode = ref.watch(dashboardStateProvider.select((s) => s.holdMode));
    final driveModeName = ref.watch(dashboardStateProvider.select((s) => s.driveModeName));
    final speedModeName = ref.watch(dashboardStateProvider.select((s) => s.speedModeName));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.black,
        border: const Border(
          bottom: BorderSide(color: Colors.white10, width: 1),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // --- MISSION CONTROLS ---
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HudArmStatus(),
              SizedBox(width: 8.w),
              HudModeLabel(
                mainText: modeName,
                subText: holdMode,
              ),
              SizedBox(width: 8.w),
              HudModeLabel(
                mainText: driveModeName,
                subText: speedModeName,
              ),
            ],
          ),

          _buildDivider(),

          // --- SYSTEM CHRONO (Expanded to Center) ---
          const Expanded(
            child: HudDateTimeLabel(),
          ),

          _buildDivider(),

          // --- TELEMETRY & STATUS ---
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HudSafetyStatus(),
                SizedBox(width: 16.w),
                const HudHandctrlStatus(),
                SizedBox(width: 16.w),
                const HudGcsStatus(),
                SizedBox(width: 16.w),
                const HudBatteryStatusIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white10,
            Colors.white10,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
