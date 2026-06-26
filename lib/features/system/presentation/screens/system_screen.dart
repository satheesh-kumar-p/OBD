import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/subsystem_list_constants.dart';
import '../../system_providers.dart';
import '../state/system_screen_state.dart';

class SystemScreen extends ConsumerWidget {
  const SystemScreen({super.key});

  static const _stage1 = [
    Subsystem.vcu,
    Subsystem.hvBattery,
    Subsystem.lvBattery,
    Subsystem.secondaryCompute,
  ];

  static const _stage2 = [
    Subsystem.dcDc48v12v,
    Subsystem.lvPdu,
    Subsystem.mainCompute,
    Subsystem.uhfRadio,
    Subsystem.lBandRadio,
    Subsystem.dcDc12v5v,
    Subsystem.ethernetSwitch,
    Subsystem.gnss,
    Subsystem.imu,
    Subsystem.lidar2d,
    Subsystem.lidar3d,
  ];

  static const _stage3 = [
    Subsystem.frontMotorController,
    Subsystem.rearMotorController,
    Subsystem.frontLeftMotor,
    Subsystem.frontRightMotor,
    Subsystem.rearLeftMotor,
    Subsystem.rearRightMotor,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemScreenStateProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStageSection('STAGE 1: IDLE', _stage1, state),
          SizedBox(height: 16.h),
          _buildStageSection('STAGE 2: KEY ON', _stage2, state),
          SizedBox(height: 16.h),
          _buildStageSection('STAGE 3: DRIVE ON', _stage3, state),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildStageSection(String title, List<Subsystem> items, SystemScreenState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 4.h, top: 4.h),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1.3, 
            mainAxisSpacing: 6.h,
            crossAxisSpacing: 6.w,
          ),
          itemBuilder: (context, index) {
            final subsystem = items[index];
            final (color, statusText) = state.getVisuals(subsystem);
            
            return _SubsystemTile(
              name: state.getLabel(subsystem),
              icon: state.getIcon(subsystem),
              color: color,
              statusText: statusText,
              isStatusActive: state.isStatusActive(subsystem),
            );
          },
        ),
      ],
    );
  }
}

class _SubsystemTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String statusText;
  final bool isStatusActive;

  const _SubsystemTile({
    required this.name,
    required this.icon,
    required this.color,
    required this.statusText,
    required this.isStatusActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isStatusActive ? color.withOpacity(0.1) : Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(
          color: isStatusActive ? color.withOpacity(0.4) : Colors.white10,
          width: 0.5.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 38.r,
              color: isStatusActive ? color : Colors.white38,
            ),
            SizedBox(height: 5.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                statusText.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
