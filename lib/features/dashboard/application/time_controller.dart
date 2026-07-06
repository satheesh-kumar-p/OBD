import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/comp_global_time_info/di/global_time_info_providers.dart';
import '../../../shared/comp_time_sync/di/comp_time_sync_providers.dart';

class TimeController extends Notifier<DateTime> {
  Timer? _localIncrementTimer;

  @override
  DateTime build() {
    _localIncrementTimer?.cancel();
    _localIncrementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      state = state.add(const Duration(milliseconds: 100));
    });

    ref.onDispose(() {
      _localIncrementTimer?.cancel();
    });

    // Listen for global time updates and only apply them when they arrive
    ref.listen(globalTimeInfoProvider, (previous, next) {
      next.whenData((info) {
        if (info != null) {
          state = info.toDateTime;
        }
      });
    });

    // Listen for time sync updates and only apply them when they arrive
    ref.listen(compTimeSyncProvider, (previous, next) {
      next.whenData((sync) {
        if (sync != null) {
          state = DateTime(
            state.year,
            state.month,
            state.day,
            sync.hour,
            sync.minute,
            sync.second,
            sync.millisecond,
          );
        }
      });
    });

    // Initialize with current value if available, otherwise use now()
    final initialGlobal = ref.read(globalTimeInfoProvider).value;
    if (initialGlobal != null) {
      return initialGlobal.toDateTime;
    }

    return DateTime.now();
  }
}

final timeControllerProvider = NotifierProvider<TimeController, DateTime>(TimeController.new);
