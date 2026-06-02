import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final healthMap = state.allHealthStatus;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        childAspectRatio: 1.15, // Slightly more vertical space for names
        mainAxisSpacing: 6.h,
        crossAxisSpacing: 6.w,
        children: [
          _tile('FORWARD LEFT MOTOR', healthMap['Front Left Motor'], Icons.settings_suggest),
          _tile('FORWARD RIGHT MOTOR', healthMap['Front Right Motor'], Icons.settings_suggest),
          _tile('VCU', healthMap['VCU'], Icons.developer_board),
          _tile('LV PDU', healthMap['LV PDU'], Icons.power),
          _tile('REAR LEFT MOTOR', healthMap['Rear Left Motor'], Icons.settings_suggest),
          _tile('REAR RIGHT MOTOR', healthMap['Rear Right Motor'], Icons.settings_suggest),
          _tile('HV BATTERY', healthMap['HV Battery'], Icons.battery_charging_full),
          _tile('LV BATTERY', healthMap['LV Battery'], Icons.battery_std),
          _tile('FRONT MOTOR CONTROLLER', healthMap['Left Motor Controller'], Icons.settings_outlined),
          _tile('REAR MOTOR CONTROLLER', healthMap['Right Motor Controller'], Icons.settings_outlined),
          _tile('DC-DC 48V-12V', healthMap['DC-DC (48V to 12V)'], Icons.ev_station),
          _tile('DC-DC 12V-5V', healthMap['DC-DC (12V to 5V)'], Icons.bolt),
          _tile('COMPUTE', healthMap['Compute Unit'], Icons.computer),
          _tile('UHF RADIO', healthMap['UHF Radio'], Icons.settings_input_antenna),
          _tile('L BAND RADIO', healthMap['L Band Radio'], Icons.radar)
        ],
      ),
    );
  }

  Widget _tile(String name, SubsystemStatus? status, IconData icon) {
    return _SubsystemTile(
      name: name,
      status: status ?? SubsystemStatus.unknown,
      icon: icon,
    );
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
      SubsystemStatus.unknown => (Colors.white54, 'Unknown'),
    };

    final isErr = status == SubsystemStatus.unhealthy;

    return Container(
      decoration: BoxDecoration(
        color: isErr ? color.withOpacity(0.15) : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isErr ? color.withOpacity(0.8) : Colors.white10,
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 46.r,
              color: isErr ? color : Colors.white54,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
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
