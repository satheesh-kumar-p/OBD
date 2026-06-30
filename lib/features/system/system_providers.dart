import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';
import '../../shared/vcu_subsystem_state/di/system_info_providers.dart';
import 'presentation/state/system_screen_state.dart';

/// Manages the state for the System Health screen by listening to VCU and Compute messages.
final systemScreenStateProvider = NotifierProvider<SystemScreenNotifier, SystemScreenState>(
  SystemScreenNotifier.new,
);

class SystemScreenNotifier extends Notifier<SystemScreenState> {
  DateTime? _lastSystemUpdate;
  DateTime? _lastComputeUpdate;

  @override
  SystemScreenState build() {
    ref.watch(stalenessTickerProvider);

    // 2. Listen to providers to track when data last arrived
    ref.listen(systemInfoProvider, (prev, next) {
      if (next.hasValue) _lastSystemUpdate = DateTime.now();
    });
    ref.listen(compSubsystemInfoProvider, (prev, next) {
      if (next.hasValue) _lastComputeUpdate = DateTime.now();
    });

    final now = DateTime.now();
    const staleThreshold = Duration(seconds: 5);

    bool isFresh(DateTime? lastUpdate) {
      return lastUpdate != null && now.difference(lastUpdate) < staleThreshold;
    }

    // 3. Return a new state object every time build() is triggered (rebuild or ticker)
    return SystemScreenState(
      systemInfo: isFresh(_lastSystemUpdate) ? ref.read(systemInfoProvider).value : null,
      computeCommInfo: isFresh(_lastComputeUpdate) ? ref.read(compSubsystemInfoProvider).value : null,
    );
  }
}
