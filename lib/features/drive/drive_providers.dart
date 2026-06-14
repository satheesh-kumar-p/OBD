import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../shared/vcu_drive_health/di/drive_info_providers.dart';
import '../../../shared/vcu_mc_temp_volt/di/mc_temp_volt_providers.dart';
import 'state/drive_state.dart';

final driveStateProvider = NotifierProvider<DriveStateNotifier, DriveState>(() {
  return DriveStateNotifier();
});

class DriveStateNotifier extends Notifier<DriveState> {
  DateTime? _lastDriveUpdate;
  DateTime? _lastMcUpdate;

  @override
  DriveState build() {
    // Listen for updates to track timestamps
    ref.listen(driveInfoProvider, (prev, next) {
      if (next.hasValue) _lastDriveUpdate = DateTime.now();
    });

    ref.listen(mcTempVoltProvider, (prev, next) {
      if (next.hasValue) _lastMcUpdate = DateTime.now();
    });

    // Watch the ticker to force a rebuild every 5 seconds for staleness checks
    ref.watch(stalenessTickerProvider);

    final now = DateTime.now();
    const stalenessThreshold = Duration(seconds: 5);

    final isDriveStale = _lastDriveUpdate == null ||
        now.difference(_lastDriveUpdate!) > stalenessThreshold;

    final isMcStale = _lastMcUpdate == null ||
        now.difference(_lastMcUpdate!) > stalenessThreshold;

    return DriveState(
      driveInfo: isDriveStale ? null : ref.read(driveInfoProvider).value,
      mcTempVolt: isMcStale ? null : ref.read(mcTempVoltProvider).value,
    );
  }
}
