import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scout_obd/features/dashboard/di/battery_info_providers.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';
import 'hud_battery_status_icon.dart';
import 'hud_date_time_label.dart';
import 'hud_handctrlStatus.dart';
import 'hud_link_status_icon.dart';
import 'hud_mode_label.dart';
import 'hud_uptime_label.dart';

class HudTopBar extends ConsumerWidget {
  const HudTopBar({
    super.key,
    required this.state,
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

    return Container(
      height: labelH,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Row(
        children: [
          HudModeLabel(
            mainText: state.modeName,
            subText: state.subModeName,
            armed: state.mode?.armed ?? false,
            height: 64.h,
            maxWidth: maxWidth,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: HudUptimeLabel(
                          height: labelH,
                          uptime: state.uptimeFormatted,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Flexible(
                        child: HudDateTimeLabel(
                          height: labelH,
                          systemTime: state.systemTimeFormatted,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HudHandctrlStatus(
                          height: labelH,
                          color: handCtrlColor,
                          size: 48.r,
                          gapAfter: 20.w,
                          status: state.computeCommInfo?.uhfRadio,
                        ),
                        HudLinkStatusIcon(
                          size: 48.r,
                          healthLevel: state.healthLevel,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        HudBatteryStatusIcon(
                          size: 40.r,
                          soc: batteryData?.soc ?? 0,
                          voltage: batteryData?.voltage ?? 0.0,
                        ),
                        if (state.mode != null) ...[
                          SizedBox(width: 16.w),
                          _buildLightIcon(
                            icon: Icons.light_mode_rounded,
                            isOn: state.mode!.headlightsOn,
                          ),
                          SizedBox(width: 8.w),
                          _buildLightIcon(
                            icon: Icons.wb_twilight_rounded,
                            isOn: state.mode!.frontFogLightsOn,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightIcon({required IconData icon, required bool isOn}) {
    return Icon(
      icon,
      size: 24.r,
      color: isOn ? Colors.cyanAccent : Colors.white10,
    );
  }
}
