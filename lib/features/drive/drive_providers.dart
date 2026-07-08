import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/vcu_drive_motor_controller_health/di/drive_mc_info_providers.dart';
import '../../../shared/vcu_drive_motor_health/di/drive_motor_info_providers.dart';
import '../../../shared/vcu_subsystem_power_state/vcu_subsystem_power_state_providers.dart';
import '../../../shared/vcu_subsystem_state/di/vcu_subsystem_info_providers.dart';
import 'state/drive_state.dart';

final driveStateProvider = NotifierProvider<DriveStateNotifier, DriveState>(() {
  return DriveStateNotifier();
});

class DriveStateNotifier extends Notifier<DriveState> {
  @override
  DriveState build() {
    return DriveState(
      motorInfo: ref.watch(driveMotorInfoProvider).value,
      mcInfo: ref.watch(driveMcInfoProvider).value,
      subsystemInfo: ref.watch(vcuSubsystemInfoProvider).value,
      powerInfo: ref.watch(vcuSubsystemPowerStateProvider).value,
    );
  }
}
