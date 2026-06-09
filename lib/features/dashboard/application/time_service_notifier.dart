import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/comp_global_time_info/di/global_time_info_providers.dart';
import '../../../shared/comp_time_sync/di/comp_time_sync_providers.dart';

class TimeServiceNotifier extends Notifier<DateTime> {
  Timer? _localIncrementTimer;

  @override
  DateTime build() {
    final globalTimeAsync = ref.watch(globalTimeInfoProvider);
    final syncTimeAsync = ref.watch(compTimeSyncProvider);

    DateTime currentTime = stateOrNull ?? DateTime.now();

    globalTimeAsync.whenData((info) {
      currentTime = info.toDateTime;
    });

    syncTimeAsync.whenData((sync) {
      currentTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        sync.hour,
        sync.minute,
        sync.second,
        sync.millisecond,
      );
    });

    _localIncrementTimer?.cancel();
    _localIncrementTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      state = state.add(const Duration(milliseconds: 10));
    });

    ref.onDispose(() {
      _localIncrementTimer?.cancel();
    });

    return currentTime;
  }
}

final timeServiceProvider = NotifierProvider<TimeServiceNotifier, DateTime>(TimeServiceNotifier.new);
