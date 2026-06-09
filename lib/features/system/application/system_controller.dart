import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../shared/comp_radio_state/di/compute_radio_state_providers.dart';
import '../../../shared/vcu_subsystem_state/di/system_info_providers.dart';
import '../presentation/state/system_screen_state.dart';

class SystemController extends Notifier<SystemScreenState> {
  @override
  SystemScreenState build() {
    // 1. Listen for System Health data (0x203)
    ref.listen(systemInfoProvider, (previous, next) {
      if (next.hasValue) {
        state = state.copyWith(
          systemInfo: next.value,
          systemInfoLastUpdate: DateTime.now(),
          now: DateTime.now(),
        );
      }
    });

    // 2. Listen for Compute data (0x20C)
    ref.listen(computeRadioStateProvider, (previous, next) {
      if (next.hasValue) {
        state = state.copyWith(
          computeCommInfo: next.value,
          computeInfoLastUpdate: DateTime.now(),
          now: DateTime.now(),
        );
      }
    });

    // 3. Listen to the global clock ticker (1Hz)
    // This forces the state to "pulse" every second.
    ref.listen(clockTickerProvider, (_, __) {
      state = state.copyWith(now: DateTime.now()); 
    });

    return SystemScreenState();
  }
}


