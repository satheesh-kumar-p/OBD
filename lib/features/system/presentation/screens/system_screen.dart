import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/subsystem_list_constants.dart';
import '../../di/system_info_providers.dart';
import '../state/system_screen_state.dart';
import '../../enums/subsystem_status_enum.dart';

class SystemScreen extends ConsumerWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemScreenStateProvider);

    if (state.systemInfo == null && state.computeCommInfo == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _buildSubsystemTable(state);
  }

  Widget _buildSubsystemTable(SystemScreenState state) {
    final statusMap = state.subsystemStatuses;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: Subsystem.values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.15,
          mainAxisSpacing: 6.h,
          crossAxisSpacing: 6.w,
        ),
        itemBuilder: (context, index) {
          final subsystem = Subsystem.values[index];
          final status = statusMap[subsystem] ?? SubsystemStatus.unknown;
          return _SubsystemTile(
            name: _getLabelForSubsystem(subsystem),
            status: status,
            icon: _getIconForSubsystem(subsystem),
          );
        },
      ),
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
      Subsystem.frontLeftMotor => 'FRONT LEFT\nMOTOR',
      Subsystem.rearLeftMotor => 'REAR LEFT\nMOTOR',
      Subsystem.frontRightMotor => 'FRONT RIGHT\nMOTOR',
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
        // Distinguishable from black background using a slightly lighter base
        color: isActionable ? color.withOpacity(0.02) : Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: isActionable ? color.withOpacity(0.5) : Colors.white10,
          width: 1.w,
        ),
        // Glow effect for actionable states (Healthy and Unhealthy)
        boxShadow: isActionable ? [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 10.r,
            spreadRadius: 1.r,
          )
        ] : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 46.r,
              color: isActionable ? color : Colors.white38,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  height: 1.1,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                statusText.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
