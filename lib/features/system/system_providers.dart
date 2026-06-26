import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';
import '../../shared/vcu_subsystem_state/di/system_info_providers.dart';
import 'presentation/state/system_screen_state.dart';

/// Manages the state for the System Health screen by listening to VCU and Compute messages.
final systemScreenStateProvider = NotifierProvider<SystemScreenNotifier, SystemScreenState>(
  SystemScreenNotifier.new,
);

class SystemScreenNotifier extends Notifier<SystemScreenState> {
  @override
  SystemScreenState build() {
    // 1. Listen for System Health data (0x203)
    ref.listen(systemInfoProvider, (previous, next) {
      next.whenData((data) {
        state = state.copyWith(
          systemInfo: data,
          systemInfoLastUpdate: DateTime.now(),
          now: DateTime.now(),
        );
      });
    });

    // 2. Listen for Compute data (0x199)
    ref.listen(compSubsystemInfoProvider, (previous, next) {
      next.whenData((data) {
        state = state.copyWith(
          computeCommInfo: data,
          computeInfoLastUpdate: DateTime.now(),
        );
      });
    });

    // 3. Periodic timer to update 'now' for staleness calculations
    final timer = Timer.periodic(const Duration(seconds: 1), (t) {
      state = state.copyWith(now: DateTime.now());
    });

    ref.onDispose(() => timer.cancel());

    return SystemScreenState();
  }
}
