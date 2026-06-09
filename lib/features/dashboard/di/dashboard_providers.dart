import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../application/dashboard_controller.dart';
import '../application/time_controller.dart';
import '../state/dashboard_state.dart';

/// Manages the currently selected tab in the dashboard.
final dashboardIndexProvider = StateProvider<int>((ref) => 0);

/// Aggregates all data required for the Dashboard UI.
/// This provider now just watches the controller and combines it with the local index.
final dashboardStateProvider = Provider<DashboardState>((ref) {
  final state = ref.watch(dashboardControllerProvider);
  final selectedIndex = ref.watch(dashboardIndexProvider);
  
  return state.copyWith(selectedIndex: selectedIndex);
});

/// Export the time controller provider if needed by other features (though core ticker is preferred)
final timeServiceProvider = timeControllerProvider;
