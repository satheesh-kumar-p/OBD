import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'application/dashboard_controller.dart';
import 'state/dashboard_state.dart';

/// Manages the currently selected tab in the dashboard.
final dashboardIndexProvider = StateProvider<int>((ref) => 0);

final dashboardControllerProvider = NotifierProvider<DashboardController, DashboardState>(DashboardController.new);

/// Aggregates all data required for the Dashboard UI.
/// This provider now just watches the controller and combines it with the local index.
final dashboardStateProvider = Provider<DashboardState>((ref) {
  final state = ref.watch(dashboardControllerProvider);
  final selectedIndex = ref.watch(dashboardIndexProvider);

  return state.copyWith(selectedIndex: selectedIndex);
});

