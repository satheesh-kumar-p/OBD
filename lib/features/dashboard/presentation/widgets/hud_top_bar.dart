import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../di/dashboard_providers.dart';
import 'hud_battery_status_icon.dart';
import 'hud_date_time_label.dart';
import 'hud_handctrlStatus.dart';
import 'hud_mode_label.dart';
import 'hud_e_stop_status.dart';
import 'hud_indicator_tile.dart';

class HudTopBar extends ConsumerWidget {
  const HudTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardStateProvider);

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
              HudModeLabel(
                mainText: state.modeName,
                subText: state.subModeName,
                armed: state.mode?.armed ?? false,
              ),
              SizedBox(width: 8.w),
              HudModeLabel(
                mainText: state.driveModeName,
                subText: state.speedModeName,
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
                const HudEStopStatus(),
                SizedBox(width: 16.w),
                const HudHandctrlStatus(),
                SizedBox(width: 16.w),
                const HudBatteryStatusIcon(),
                if (state.mode != null) ...[
                  SizedBox(width: 20.w),
                  HudIndicatorTile(
                    icon: Icons.light_mode_rounded,
                    color: state.headlightsColor,
                    label: 'HL',
                    isActive: state.mode!.headlightsOn,
                  ),
                  SizedBox(width: 8.w),
                  HudIndicatorTile(
                    icon: Icons.wb_twilight_rounded,
                    color: state.fogLightsColor,
                    label: 'FOG',
                    isActive: state.mode!.frontFogLightsOn,
                  ),
                ],
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
