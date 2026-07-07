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
    // Listen for updates from the providers.
    
    ref.listen(driveMotorInfoProvider, (prev, next) {
      if (next.hasValue) {
        state = state.copyWith(
          motorInfo: next.value,
          clearMotorInfo: next.value == null,
        );
      }
    });

    ref.listen(driveMcInfoProvider, (prev, next) {
      if (next.hasValue) {
        state = state.copyWith(
          mcInfo: next.value,
          clearMcInfo: next.value == null,
        );
      }
    });

    ref.listen(vcuSubsystemInfoProvider, (prev, next) {
      if (next.hasValue) {
        state = state.copyWith(
          subsystemInfo: next.value,
          clearSubsystemInfo: next.value == null,
        );
      }
    });

    ref.listen(vcuSubsystemPowerStateProvider, (prev, next) {
      if (next.hasValue) {
        state = state.copyWith(
          powerInfo: next.value,
          clearPowerInfo: next.value == null,
        );
      }
    });

    return const DriveState();
  }
}
