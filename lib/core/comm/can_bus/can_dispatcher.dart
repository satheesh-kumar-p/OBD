import 'dart:async';
import 'package:collection/collection.dart';
import 'can_frame.dart';

/// Strategy for handling incoming CAN messages.
enum DispatchStrategy {
  /// Emit frames as soon as they arrive.
  passThrough,

  /// Emit only the latest frame at a fixed frequency.
  sample,
}

/// Configuration for a specific CAN message ID.
class MessageConfig {
  final int messageId;
  final DispatchStrategy strategy;
  final double frequencyHz;

  const MessageConfig({
    required this.messageId,
    this.strategy = DispatchStrategy.passThrough,
    this.frequencyHz = 0,
  });

  const MessageConfig.sample(this.messageId, this.frequencyHz)
      : strategy = DispatchStrategy.sample;

  const MessageConfig.passThrough(this.messageId)
      : strategy = DispatchStrategy.passThrough,
        frequencyHz = 0;

  int get intervalMs => frequencyHz > 0 ? (1000 / frequencyHz).round() : 0;
}

/// Internal task for the priority queue.
class _ScheduledTask {
  final int messageId;
  DateTime nextTargetTime;

  _ScheduledTask(this.messageId, this.nextTargetTime);
}

/// Dispatches CAN frames based on per-message configurations.
/// 
/// Uses a Priority Queue (Min-Heap) for efficient scheduling, a watchdog
/// for resource cleanup, and drift-correction for stable telemetry frequency.
class CanMessageDispatcher {
  final Map<int, MessageConfig> _configs;
  final StreamController<CanFrame> _outputController = StreamController<CanFrame>.broadcast();
  
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

  CanMessageDispatcher({
    List<MessageConfig> configs = const [],
    Duration tickInterval = const Duration(milliseconds: 10),
  }) : _configs = {for (var c in configs) c.messageId: c} {
    _startMasterTicker(tickInterval);
    _startWatchdog();
  }

  /// The output stream of processed (filtered/sampled) frames.
  Stream<CanFrame> get frameStream => _outputController.stream;

  /// Feeds a raw CAN frame into the dispatcher.
  void dispatch(CanFrame frame) {
    final now = DateTime.now();
    _lastSeen[frame.id] = now;

    final config = _configs[frame.id];

    // Default to pass-through if no config found
    if (config == null || config.strategy == DispatchStrategy.passThrough) {
      _outputController.add(frame);
      return;
    }

    if (config.strategy == DispatchStrategy.sample) {
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
        _outputController.add(frame);
        
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
        // We stop the sampling cycle for this ID to save CPU.
        // It will restart automatically when the next frame for this ID arrives.
        _activeInQueue.remove(task.messageId);
      }
    }
  }

  void _startWatchdog() {
    // Every 5 seconds, purge info for sensors that haven't sent data in a while.
    _watchdogTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final now = DateTime.now();
      final staleThreshold = now.subtract(const Duration(seconds: 10));

      _lastSeen.removeWhere((id, lastTime) {
        if (lastTime.isBefore(staleThreshold)) {
          // Remove from all state maps to act as "garbage collection"
          _latestFrames.remove(id);
          // Note: Priority Queue cleanup is handled naturally by _tick 
          // when it finds no data in _latestFrames.
          return true;
        }
        return false;
      });
    });
  }

  void dispose() {
    _masterTicker?.cancel();
    _watchdogTimer?.cancel();
    _latestFrames.clear();
    _activeInQueue.clear();
    _lastSeen.clear();
    _scheduler.clear();
    _outputController.close();
  }
}
