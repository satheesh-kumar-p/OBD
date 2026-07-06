import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/vcu_drive_health/di/drive_info_providers.dart';
import '../../../shared/vcu_mc_temp_volt/di/mc_temp_volt_providers.dart';
import 'state/drive_state.dart';

final driveStateProvider = NotifierProvider<DriveStateNotifier, DriveState>(() {
  return DriveStateNotifier();
});

class DriveStateNotifier extends Notifier<DriveState> {
  @override
  DriveState build() {
    // Listen for updates from the providers.
    // These providers now automatically emit null if data goes stale
    // because the MessageDispatcher handles the timing logic.
    
    ref.listen(driveInfoProvider, (prev, next) {
      if (next.hasValue) {
        state = state.copyWith(
          driveInfo: next.value,
          clearDriveInfo: next.value == null,
        );
      }
    });

    ref.listen(mcTempVoltProvider, (prev, next) {
      if (next.hasValue) {
        state = state.copyWith(
          mcTempVolt: next.value,
          clearMcTempVolt: next.value == null,
        );
      }
    });

    return const DriveState();
  }
}
