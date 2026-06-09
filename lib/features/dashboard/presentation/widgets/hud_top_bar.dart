import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../di/dashboard_providers.dart';
import '../../state/dashboard_state.dart';
import 'hud_battery_status_icon.dart';
import 'hud_date_time_label.dart';
import 'hud_handctrlStatus.dart';
import 'hud_e_stop_status.dart';
import 'hud_mode_label.dart';

class HudTopBar extends ConsumerWidget {
  const HudTopBar({
    super.key,
    required this.state, // Kept for other properties, but we will watch time separately
    required this.height,
    required this.horizontalPadding,
  });

  final DashboardState state;
  final double height;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const handCtrlColor = Colors.white70;

    final labelH = height;
    final maxWidth = 576.w;
    final batteryData = state.battery;

    // OPTIMIZATION: Only rebuild this part of the row when the second changes
    final systemTime = ref.watch(dashboardStateProvider.select((s) => s.systemTimeFormatted));

    return Container(
      height: labelH,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
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
          // --- GROUP 1: MISSION CONTROL ---
          _HudGroup(
            label: 'MISSION',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HudModeLabel(
                  mainText: state.modeName,
                  subText: state.subModeName,
                  armed: state.mode?.armed ?? false,
                  height: 56.h,
                  maxWidth: maxWidth,
                ),
                SizedBox(width: 8.w),
                HudModeLabel(
                  mainText: state.driveModeName,
                  subText: state.speedModeName,
                  height: 56.h,
                  maxWidth: maxWidth / 1.5,
                ),
              ],
            ),
          ),

          _buildDivider(),

          // --- GROUP 2: SYSTEM CHRONO ---
          Expanded(
            child: _HudGroup(
              label: 'SYSTEM CHRONO',
              alignment: Alignment.center,
              child: HudDateTimeLabel(
                height: labelH,
                systemTime: systemTime,
              ),
            ),
          ),

          _buildDivider(),

          // --- GROUP 3: TELEMETRY & STATUS ---
          _HudGroup(
            label: 'STATUS',
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HudEStopStatus(
                    height: labelH,
                    color: handCtrlColor,
                    size: 44.r,
                    gapAfter: 16.w,
                    status: state.eStopInfo?.status,
                  ),
                  HudHandctrlStatus(
                    height: labelH,
                    color: handCtrlColor,
                    size: 44.r,
                    gapAfter: 16.w,
                    status: state.computeCommInfo?.uhfRadio,
                  ),
                  HudBatteryStatusIcon(
                    size: 38.r,
                    hvBatterySoc: batteryData?.hvBatterySoc ?? 0,
                    lvBatterySoc: batteryData?.lvBatterySoc ?? 0,
                  ),
                  if (state.mode != null) ...[
                    SizedBox(width: 20.w),
                    _buildIndicatorTile(
                      icon: Icons.light_mode_rounded,
                      isOn: state.mode!.headlightsOn,
                      label: 'HL',
                    ),
                    SizedBox(width: 8.w),
                    _buildIndicatorTile(
                      icon: Icons.wb_twilight_rounded,
                      isOn: state.mode!.frontFogLightsOn,
                      label: 'FOG',
                    ),
                  ],
                ],
              ),
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
      decoration: BoxDecoration(
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

  Widget _buildIndicatorTile({
    required IconData icon,
    required bool isOn,
    required String label,
  }) {
    final activeColor = Colors.orangeAccent;
    final color = isOn ? activeColor : Colors.white10;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOn ? activeColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.r, color: color),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HudGroup extends StatelessWidget {
  final String label;
  final Widget child;
  final Alignment alignment;

  const _HudGroup({
    required this.label,
    required this.child,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment == Alignment.center
          ? CrossAxisAlignment.center
          : alignment == Alignment.centerRight
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white24,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}
