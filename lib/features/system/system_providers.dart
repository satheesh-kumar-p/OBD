import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';
import '../../shared/vcu_subsystem_state/di/system_info_providers.dart';
import 'presentation/state/system_screen_state.dart';

/// Manages the state for the System Health screen by listening to VCU and Compute messages.
final StateProvider<SystemScreenState> systemScreenStateProvider = StateProvider<SystemScreenState>((ref) {
  // 1. Listen for System Health data (0x203)
  ref.listen(systemInfoProvider, (previous, next) {
    if (next.hasValue) {
      ref.read(systemScreenStateProvider.notifier).state = ref.read(systemScreenStateProvider.notifier).state.copyWith(
        systemInfo: next.value,
        systemInfoLastUpdate: DateTime.now(),
        now: DateTime.now(),
      );
    }
  });

  // 2. Listen for Compute data (0x199)
  ref.listen(compSubsystemInfoProvider, (previous, next) {
    if (next.hasValue) {
      ref.read(systemScreenStateProvider.notifier).state = ref.read(systemScreenStateProvider.notifier).state.copyWith(
        computeCommInfo: next.value,
        computeInfoLastUpdate: DateTime.now(),
      );
    }
  });

  // 3. Periodic timer to update 'now' for staleness calculations (the 5s timeout)
  final timer = Timer.periodic(const Duration(seconds: 1), (t) {
    ref.read(systemScreenStateProvider.notifier).state = ref.read(systemScreenStateProvider.notifier).state.copyWith(now: DateTime.now());
  });

  ref.onDispose(() => timer.cancel());

  return SystemScreenState();
});
