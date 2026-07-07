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

class CommonScreen extends ConsumerWidget {
  const CommonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const ArmStatus(),
              SizedBox(width: 8.w),
              const MissionModeLabel(),
              SizedBox(width: 8.w),
              const DriveModeLabel(),
            ],
          ),

          _buildDivider(),

          // --- SYSTEM CHRONO (Expanded to Center) ---
          const Expanded(
            child: DateTimeLabel(),
          ),

          _buildDivider(),

          // --- TELEMETRY & STATUS ---
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SafetyStatus(),
                SizedBox(width: 16.w),
                const HandCtrlStatus(),
                SizedBox(width: 16.w),
                const GcsStatus(),
                SizedBox(width: 16.w),
                const BatteryStatusIcon(),
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
