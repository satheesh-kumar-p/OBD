import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/features/dashboard/di/battery_info_providers.dart';
import 'package:scout_obd/features/dashboard/di/mode_info_providers.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';
import 'package:scout_obd/shared/di/global_time_info_providers.dart';

import '../../system/di/system_info_providers.dart';

/// Provides a ticker that emits every second to refresh time-dependent UI.
final clockTickerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (tick) => tick);
});

/// Manages the currently selected tab in the dashboard.
final dashboardIndexProvider = StateProvider<int>((ref) => 0);

/// Aggregates all data required for the Dashboard UI.
/// This provider handles the dependency between the Transport Connection and Data Services.
final dashboardStateProvider = Provider<DashboardState>((ref) {
  // 1. Watch the CAN connection state instead of MAVLink
  final connectionAsync = ref.watch(canConnectionProvider);

  // 2. If we aren't connected yet, return a default/disconnected state 
  if (connectionAsync.asData == null) {
    return DashboardState(
      selectedIndex: ref.watch(dashboardIndexProvider),
    );
  }

  // 3. For now, only CAN-based features are active.
  final selectedIndex = ref.watch(dashboardIndexProvider);
  final modeAsync = ref.watch(modeInfoProvider);
  final batteryAsync = ref.watch(batteryInfoProvider);
  final systemAsync = ref.watch(systemInfoProvider);
  final computeCommAsync = ref.watch(computeCommInfoProvider);
  final globalTimeAsync = ref.watch(globalTimeProvider);

  // 4. Force a UI refresh every second even if data doesn't change
  // (e.g. to keep the internal clock ticking visually)
  ref.watch(clockTickerProvider);

  return DashboardState(
    selectedIndex: selectedIndex,
    mode: modeAsync.asData?.value,
    battery: batteryAsync.asData?.value,
    systemInfo: systemAsync.asData?.value,
    computeCommInfo: computeCommAsync.asData?.value,
    globalTime: globalTimeAsync.asData?.value,
  );
});
