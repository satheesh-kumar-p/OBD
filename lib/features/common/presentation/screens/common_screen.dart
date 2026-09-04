import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/mission_mode_label.dart';
import '../widgets/drive_mode_label.dart';
import '../widgets/arm_status.dart';
import '../widgets/gcs_status.dart';
import '../widgets/safety_status.dart';
import '../widgets/hand_ctrl_status.dart';
import '../widgets/date_time_label.dart';
import '../widgets/battery_status_icon.dart';
import '../../common_providers.dart';

class CommonScreen extends ConsumerWidget {
  const CommonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lvBattery = ref.watch(commonScreenStateProvider.select((s) => s.lvBattery));
    final hvBattery = ref.watch(commonScreenStateProvider.select((s) => s.hvBattery));

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
          Expanded(
            flex: 4,
            child: _buildScaledGroup(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ArmStatus(),
                  SizedBox(width: 15.w),
                  const MissionModeLabel(),
                  SizedBox(width: 15.w),
                  const DriveModeLabel(),
                ],
              ),
            ),
          ),

          _buildDivider(),

          // --- SYSTEM CHRONO (Expanded to Center) ---
          Expanded(
            flex: 3,
            child: _buildScaledGroup(
              alignment: Alignment.center,
              child: const DateTimeLabel(),
            ),
          ),

          _buildDivider(),

          // --- TELEMETRY & STATUS ---
          Expanded(
            flex: 5,
            child: _buildScaledGroup(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SafetyStatus(),
                  SizedBox(width: 20.w),
                  const HandCtrlStatus(),
                  SizedBox(width: 15.w),
                  const GcsStatus(),
                  SizedBox(width: 15.w),
                  BatteryStatus(state: lvBattery),
                  SizedBox(width: 15.w),
                  BatteryStatus(state: hvBattery),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaledGroup({
    required Alignment alignment,
    required Widget child,
  }) {
    return Align(
      alignment: alignment,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: child,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
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
