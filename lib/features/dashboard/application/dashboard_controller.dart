import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../shared/comp_mode_status/di/mode_info_providers.dart';
import '../../../shared/comp_radio_state/di/comp_radio_state_providers.dart';
import '../../../shared/vcu_estop_status/di/e_stop_info_providers.dart';
import '../../../shared/vcu_power_status/di/battery_info_providers.dart';
import '../../../shared/vcu_subsystem_state/di/system_info_providers.dart';
import '../state/dashboard_state.dart';
import 'time_controller.dart';

class DashboardController extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    // 1. Watch the CAN connection state
    final connectionAsync = ref.watch(canConnectionProvider);

    // 2. Watch local UI state
    // Note: dashboardIndexProvider should be moved to this controller's state if we want full encapsulation,
    // but for now we can still watch it if it's in dashboard_providers.
    // However, the rule says "DI should import only what is being provided by the controller".
    // So let's keep it simple for now as per the "old architecture" where dashboardIndexProvider was separate.

    // 3. Watch all shared providers
    final modeAsync = ref.watch(modeInfoProvider);
    final batteryAsync = ref.watch(batteryInfoProvider);
    final eStopAsync = ref.watch(eStopInfoProvider);
    final systemAsync = ref.watch(systemInfoProvider);
    final computeCommAsync = ref.watch(compRadioStateProvider);
    final globalTime = ref.watch(timeControllerProvider);

    // 4. Watch core ticker for UI updates
    ref.watch(clockTickerProvider);

    // If we aren't connected yet, return a default/disconnected state 
    if (connectionAsync.asData == null) {
      return const DashboardState();
    }

    return DashboardState(
      mode: modeAsync.asData?.value,
      battery: batteryAsync.asData?.value,
      eStopInfo: eStopAsync.asData?.value,
      systemInfo: systemAsync.asData?.value,
      compRadioInfo: computeCommAsync.asData?.value,
      globalTime: globalTime,
    );
  }

  void updateSelectedIndex(int index) {
    // This logic could be moved here from the UI if we want the controller to handle all dashboard events.
  }
}

final dashboardControllerProvider = NotifierProvider<DashboardController, DashboardState>(DashboardController.new);
