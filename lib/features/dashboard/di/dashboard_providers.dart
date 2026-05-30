import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';
import 'package:scout_obd/shared/di/heartbeat_providers.dart';
import 'package:scout_obd/shared/di/link_status_providers.dart';
import 'package:scout_obd/shared/di/timesync_providers.dart';
import 'package:scout_obd/shared/di/mode_providers.dart';

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
  
  return DashboardState(
    selectedIndex: selectedIndex,
  );
});
