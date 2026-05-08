import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/features/compute/di/ugv_subsystem_providers.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';
import 'package:scout_obd/shared/di/heartbeat_providers.dart';
import 'package:scout_obd/shared/di/link_status_providers.dart';
import 'package:scout_obd/shared/di/timesync_providers.dart';
import 'package:scout_obd/shared/di/ugv_mode_providers.dart';

/// Provides a ticker that emits every second to refresh time-dependent UI.
final clockTickerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (tick) => tick);
});

/// Manages the currently selected tab in the dashboard.
final dashboardIndexProvider = StateProvider<int>((ref) => 0);

/// Aggregates all data required for the Dashboard UI.
/// This provider handles the dependency between the Transport Connection and Data Services.
final dashboardStateProvider = Provider<DashboardState>((ref) {
  // 1. Watch the connection state first.
  final connectionAsync = ref.watch(commConnectionProvider);

  // 2. If we aren't connected yet, return a default/disconnected state 
  // and do NOT watch the heartbeat/timesync providers to avoid premature sending.
  if (connectionAsync.asData == null) {
    return DashboardState(
      selectedIndex: ref.watch(dashboardIndexProvider),
    );
  }

  // 3. Once connected, safely watch the data streams.
  ref.watch(clockTickerProvider);
  
  final linkStatusValue = ref.watch(linkStatusProvider(AppConstants.primaryLinkId)).asData?.value;
  final heartbeatValue = ref.watch(heartbeatProvider(AppConstants.primaryLinkId)).asData?.value;
  final timeSyncValue = ref.watch(timeSyncProvider(AppConstants.primaryLinkId)).asData?.value;
  final systemTimeValue = ref.watch(systemTimeProvider(AppConstants.primaryLinkId)).asData?.value;
  final mode = ref.watch(ugvModeProvider(AppConstants.primaryLinkId)).asData?.value;
  final selectedIndex = ref.watch(dashboardIndexProvider);

  // If linkStatusValue is null, but connectionAsync has data, we assume connected initially.
  final isConnected = linkStatusValue?.isConnected ?? true;

  return DashboardState(
    linkStatus: linkStatusValue?.copyWith(isConnected: isConnected),
    heartbeat: heartbeatValue,
    timeSync: timeSyncValue,
    systemTime: systemTimeValue,
    mode: mode,
    selectedIndex: selectedIndex,
  );
});
