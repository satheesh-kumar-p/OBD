import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'time_controller.dart';
import '../state/dashboard_state.dart';
import '../../../core/di/injection_container.dart';
import '../../../shared/vcu_status/vcu_status_providers.dart';
import '../../../shared/comp_mode_status/di/mode_info_providers.dart';
import '../../../shared/vcu_estop_status/di/e_stop_info_providers.dart';
import '../../../shared/vcu_power_status/di/battery_info_providers.dart';
import '../../../shared/vcu_subsystem_state/di/system_info_providers.dart';
import '../../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';

class DashboardController extends Notifier<DashboardState> {
  DateTime? _lastBatteryUpdate;
  DateTime? _lastModeUpdate;
  DateTime? _lastEStopUpdate;
  DateTime? _lastSystemUpdate;
  DateTime? _lastComputeUpdate;
  DateTime? _lastVcuStatusUpdate;

  @override
  DashboardState build() {
    ref.watch(stalenessTickerProvider);
    
    final now = DateTime.now();
    const stalenessThreshold = Duration(seconds: 5);

    // Listen to providers to update last received timestamps
    ref.listen(batteryInfoProvider, (prev, next) {
      if (next.hasValue) _lastBatteryUpdate = DateTime.now();
    });
    ref.listen(modeInfoProvider, (prev, next) {
      if (next.hasValue) _lastModeUpdate = DateTime.now();
    });
    ref.listen(eStopInfoProvider, (prev, next) {
      if (next.hasValue) _lastEStopUpdate = DateTime.now();
    });
    ref.listen(systemInfoProvider, (prev, next) {
      if (next.hasValue) _lastSystemUpdate = DateTime.now();
    });
    ref.listen(compSubsystemInfoProvider, (prev, next) {
      if (next.hasValue) _lastComputeUpdate = DateTime.now();
    });
    ref.listen(vcuStatusProvider, (prev, next) {
      if (next.hasValue) _lastVcuStatusUpdate = DateTime.now();
    });

    final connectionAsync = ref.watch(commConnectionProvider);
    final globalTime = ref.watch(timeControllerProvider);

    // If we aren't connected yet, return a default/disconnected state
    if (connectionAsync.asData == null) {
      return const DashboardState();
    }

    // Helper to determine if data is fresh
    bool isFresh(DateTime? lastUpdate) {
      return lastUpdate != null && now.difference(lastUpdate) < stalenessThreshold;
    }

    return DashboardState(
      mode: isFresh(_lastModeUpdate) ? ref.read(modeInfoProvider).value : null,
      battery: isFresh(_lastBatteryUpdate) ? ref.read(batteryInfoProvider).value : null,
      eStopInfo: isFresh(_lastEStopUpdate) ? ref.read(eStopInfoProvider).value : null,
      systemInfo: isFresh(_lastSystemUpdate) ? ref.read(systemInfoProvider).value : null,
      compSubsystemState: isFresh(_lastComputeUpdate) ? ref.read(compSubsystemInfoProvider).value : null,
      vcuStatus: isFresh(_lastVcuStatusUpdate) ? ref.read(vcuStatusProvider).value : null,
      globalTime: globalTime,
    );
  }
}
