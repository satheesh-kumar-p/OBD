import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../di/dashboard_providers.dart';
import '../../state/dashboard_state.dart';
import 'hud_battery_status_icon.dart';
import 'hud_date_time_label.dart';
import 'hud_handctrlStatus.dart';
import 'hud_mode_label.dart';
import '../../../../shared/vcu_estop_status/enums/e_stop_status_enum.dart';

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

    final systemTime = ref.watch(dashboardStateProvider.select((s) => s.systemTimeFormatted));

    return Container(
      height: labelH,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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

          _buildDivider(),

          // --- SYSTEM CHRONO (Expanded to Center) ---
          Expanded(
            child: Center(
              child: HudDateTimeLabel(
                height: labelH,
                systemTime: systemTime,
              ),
            ),
          ),

          _buildDivider(),

          // --- TELEMETRY & STATUS ---
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _VehicleSafetyIndicator(
                  status: state.eStopInfo?.status,
                  size: 44.r,
                ),
                SizedBox(width: 16.w),
                HudHandctrlStatus(
                  height: labelH,
                  color: handCtrlColor,
                  size: 44.r,
                  gapAfter: 16.w,
                  status: state.compRadioInfo?.uhfRadio,
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

class _VehicleSafetyIndicator extends StatelessWidget {
  final EStopStatus? status;
  final double size;

  const _VehicleSafetyIndicator({
    this.status,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isEngaged = status == EStopStatus.engaged;
    
    // Background circle color based on status
    final circleColor = switch (status) {
      EStopStatus.engaged => const Color(0xFFFF3B3B),
      EStopStatus.released => const Color(0xFF00FF66).withOpacity(0.4),
      EStopStatus.unknown || null => Colors.white12,
    };

    // Text color is always white, but duller when not engaged
    final textColor = isEngaged ? Colors.white : Colors.white.withOpacity(0.6);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isEngaged ? circleColor : circleColor.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: isEngaged ? circleColor : circleColor.withOpacity(0.2),
          width: 1.5.r,
        ),
      ),
      child: Center(
        child: Text(
          'STOP',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
