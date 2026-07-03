import 'dart:async';
import 'package:collection/collection.dart';

import '../comm/can_bus/can_frame.dart';
import '../enums/dispatch_strategy_enum.dart';
import 'message_config.dart';

/// Internal task for the priority queue.
class _ScheduledTask {
  final int messageId;
  DateTime nextTargetTime;

  _ScheduledTask(this.messageId, this.nextTargetTime);
}

/// Dispatches CAN frames based on per-message configurations.
/// Uses a Priority Queue (Min-Heap) for efficient scheduling, per-ID streams
/// for reactive consumption, and active staleness invalidation.
class MessageDispatcher {
  final Map<int, MessageConfig> _configs;
  final Set<int> _whitelist;
  final Duration _staleThreshold;
  
  /// Per-ID broadcast streams. Emits [null] when data goes stale.
  final Map<int, StreamController<CanFrame?>> _controllers = {};
  
  // Storage: Always holds the latest frame for an ID.
  final Map<int, CanFrame> _latestFrames = {};
  
  // Scheduling: Min-Heap to track when each ID should be emitted next.
  final PriorityQueue<_ScheduledTask> _scheduler = PriorityQueue<_ScheduledTask>(
    (a, b) => a.nextTargetTime.compareTo(b.nextTargetTime)
  );
  
  // Active tracking to avoid duplicate tasks in the queue.
  final Set<int> _activeInQueue = {};
  
  // Watchdog: Tracks last seen time to purge inactive sensors.
  final Map<int, DateTime> _lastSeen = {};

  Timer? _masterTicker;
  Timer? _watchdogTimer;

  MessageDispatcher({
    List<MessageConfig> configs = const [],
    Set<int> whitelist = const {},
    Duration tickInterval = const Duration(milliseconds: 10),
    required Duration staleThreshold,
  }) : _configs = {for (var c in configs) c.messageId: c},
       _whitelist = whitelist,
       _staleThreshold = staleThreshold {
    _startMasterTicker(tickInterval);
    _startWatchdog();
  }

  /// Returns a dedicated broadcast stream for a specific [messageId].
  /// Emits [CanFrame] when data arrives, and [null] if data becomes stale.
  Stream<CanFrame?> streamFor(int messageId) {
    return _getOrCreateController(messageId).stream;
  }

  /// Feeds a raw CAN frame into the dispatcher.
  void dispatch(CanFrame frame) {
    // GUARDRAIL: Only process whitelisted messages
    if (_whitelist.isNotEmpty && !_whitelist.contains(frame.id)) {
      return;
    }

    final now = DateTime.now();
    _lastSeen[frame.id] = now;

    final config = _configs[frame.id];

    // Default to pass-through if no config found
    if (config == null || config.strategy == DispatchStrategy.passThrough) {
      _emit(frame.id, frame);
      return;
    }

    if (config.strategy == DispatchStrategy.throttle) {
      _latestFrames[frame.id] = frame;
      
      // If not already in schedule, start the sampling cycle
      if (!_activeInQueue.contains(frame.id)) {
        final firstTarget = now.add(Duration(milliseconds: config.intervalMs));
        _scheduler.add(_ScheduledTask(frame.id, firstTarget));
        _activeInQueue.add(frame.id);
      }
    }
  }

  void _startMasterTicker(Duration interval) {
    _masterTicker = Timer.periodic(interval, (_) => _tick());
  }

  void _tick() {
    if (_scheduler.isEmpty) return;

    final now = DateTime.now();

    // Process all tasks that are due (or overdue)
    while (_scheduler.isNotEmpty && _scheduler.first.nextTargetTime.isBefore(now)) {
      final task = _scheduler.removeFirst();
      final frame = _latestFrames.remove(task.messageId);

      if (frame != null) {
        // We have new data! Emit and reschedule.
        _emit(task.messageId, frame);
        
        final config = _configs[task.messageId]!;
        
        // SELF-CORRECTION: Calculate next target from PREVIOUS target to prevent drift.
        var nextTarget = task.nextTargetTime.add(Duration(milliseconds: config.intervalMs));
        
        // PROTECTION: If we are extremely behind (e.g. app freeze), reset to avoid burst.
        if (nextTarget.isBefore(now.subtract(Duration(milliseconds: config.intervalMs * 2)))) {
          nextTarget = now.add(Duration(milliseconds: config.intervalMs));
        }

        task.nextTargetTime = nextTarget;
        _scheduler.add(task);
      } else {
        // NO NEW DATA: The bus has been quiet for this ID.
        // We stop the throttling for this ID to save CPU.
        _activeInQueue.remove(task.messageId);
      }
    }
  }

  void _startWatchdog() {
    // Watchdog Polling is hardcoded to every 3 seconds
    _watchdogTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final now = DateTime.now();
      final staleLimit = now.subtract(_staleThreshold);

      final staleIds = _lastSeen.entries
          .where((e) => e.value.isBefore(staleLimit))
          .map((e) => e.key)
          .toList();

      for (final id in staleIds) {
        // 1. Signal staleness to listeners
        _emit(id, null);

        // 2. Cleanup resources
        // Note: We DO NOT close the controller or remove it from the map.
        // This ensures that when data returns, the listeners are still active.
        _lastSeen.remove(id);
        _latestFrames.remove(id);
      }
    });
  }

  void _emit(int id, CanFrame? frame) {
    final controller = _controllers[id];
    if (controller != null && !controller.isClosed) {
      controller.add(frame);
    }
  }

  StreamController<CanFrame?> _getOrCreateController(int id) {
    return _controllers.putIfAbsent(
      id,
      () => StreamController<CanFrame?>.broadcast(),
    );
  }

  void dispose() {
    _masterTicker?.cancel();
    _watchdogTimer?.cancel();
    _latestFrames.clear();
    _activeInQueue.clear();
    _lastSeen.clear();
    _scheduler.clear();
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
