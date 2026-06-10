import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/subsystem_list_constants.dart';
import '../../../../core/enums/subsystem_status_enum.dart';
import '../../di/system_providers.dart';

class SystemScreen extends ConsumerWidget {
  const SystemScreen({super.key});

  static const _stage1 = [
    Subsystem.vcu,
    Subsystem.hvBattery,
    Subsystem.lvBattery,
  ];

  static const _stage2 = [
    Subsystem.dcDc48v12v,
    Subsystem.lvPdu,
    Subsystem.compute,
    Subsystem.uhfRadio,
    Subsystem.dcDc12v5v,
    Subsystem.lBandRadio,
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
    // OPTIMIZATION: Only rebuild the entire screen if the statuses actually change.
    final statusMap = ref.watch(systemScreenStateProvider.select((s) => s.subsystemStatuses));

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStageSection('STAGE 1: IDLE', _stage1, statusMap),
          SizedBox(height: 16.h),
          _buildStageSection('STAGE 2: KEY ON', _stage2, statusMap),
          SizedBox(height: 16.h),
          _buildStageSection('STAGE 3: DRIVE ON', _stage3, statusMap),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildStageSection(String title, List<Subsystem> items, Map<Subsystem, SubsystemStatus> statusMap) {
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
            childAspectRatio: 1.3, // Short and wide
            mainAxisSpacing: 6.h,
            crossAxisSpacing: 6.w,
          ),
          itemBuilder: (context, index) {
            final subsystem = items[index];
            final status = statusMap[subsystem] ?? SubsystemStatus.unknown;
            return _SubsystemTile(
              name: _getLabelForSubsystem(subsystem),
              status: status,
              icon: _getIconForSubsystem(subsystem),
            );
          },
        ),
      ],
    );
  }

  String _getLabelForSubsystem(Subsystem subsystem) {
    return switch (subsystem) {
      Subsystem.frontMotorController => 'FRONT MOTOR\nCONTROLLER',
      Subsystem.rearMotorController => 'REAR MOTOR\nCONTROLLER',
      Subsystem.hvBattery => 'HV BATTERY',
      Subsystem.lvBattery => 'LV BATTERY',
      Subsystem.lvPdu => 'LV PDU',
      Subsystem.dcDc48v12v => 'DC-DC\n48V-12V',
      Subsystem.dcDc12v5v => 'DC-DC\n12V-5V',
      Subsystem.vcu => 'VCU',
      Subsystem.frontLeftMotor => 'FORWARD LEFT\nMOTOR',
      Subsystem.rearLeftMotor => 'REAR LEFT\nMOTOR',
      Subsystem.frontRightMotor => 'FORWARD RIGHT\nMOTOR',
      Subsystem.rearRightMotor => 'REAR RIGHT\nMOTOR',
      Subsystem.uhfRadio => 'UHF RADIO',
      Subsystem.lBandRadio => 'L BAND RADIO',
      Subsystem.compute => 'COMPUTE',
    };
  }

  IconData _getIconForSubsystem(Subsystem subsystem) {
    return switch (subsystem) {
      Subsystem.frontLeftMotor ||
      Subsystem.frontRightMotor ||
      Subsystem.rearLeftMotor ||
      Subsystem.rearRightMotor =>
        Icons.settings_suggest,
      Subsystem.vcu => Icons.developer_board,
      Subsystem.lvPdu => Icons.power,
      Subsystem.hvBattery => Icons.battery_charging_full,
      Subsystem.lvBattery => Icons.battery_std,
      Subsystem.frontMotorController ||
      Subsystem.rearMotorController =>
        Icons.settings_outlined,
      Subsystem.dcDc48v12v => Icons.ev_station,
      Subsystem.dcDc12v5v => Icons.bolt,
      Subsystem.compute => Icons.computer,
      Subsystem.uhfRadio => Icons.settings_input_antenna,
      Subsystem.lBandRadio => Icons.radar,
    };
  }
}

class _SubsystemTile extends StatelessWidget {
  final String name;
  final SubsystemStatus status;
  final IconData icon;

  const _SubsystemTile({
    required this.name,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final (Color color, String statusText) = switch (status) {
      SubsystemStatus.healthy => (const Color(0xFF00FF66), 'Healthy'),
      SubsystemStatus.unhealthy => (const Color(0xFFFF3B3B), 'Fault Detected'),
      SubsystemStatus.noCommunication => (const Color(0xFF93A9B5), 'Not Connected'),
      SubsystemStatus.unknown => (Colors.white24, 'Unknown'),
    };

    final isActionable = status == SubsystemStatus.healthy || status == SubsystemStatus.unhealthy;

    return Container(
      decoration: BoxDecoration(
        color: isActionable ? color.withOpacity(0.1) : Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(
          color: isActionable ? color.withOpacity(0.4) : Colors.white10,
          width: 0.5.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. ICON at the top
            Icon(
              icon,
              size: 38.r,
              color: isActionable ? color : Colors.white38,
            ),
            SizedBox(height: 5.h),
            // 2. TITLE in the middle
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
            // 3. VALUE at the bottom
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
