import 'dart:async';
import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../mappers/comp_time_sync_mapper.dart';
import '../mappers/global_time_info_mapper.dart';

class GlobalTimeInfoRepository {
  final CanCommManager _canManager;
  final Logger _logger;

  DateTime _currentInternalTime = DateTime.now();
  bool _hasInitialDate = false;

  final _timeCtrl = StreamController<DateTime>.broadcast();
  Timer? _localIncrementTimer;
  StreamSubscription? _globalTimeSub;
  StreamSubscription? _syncTimeSub;

  int _lastEmittedSecond = -1;

  GlobalTimeInfoRepository({
    required CanCommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
        _logger = logger;

  void start() {
    if (_localIncrementTimer != null) return;
    _logger.info('Starting Global Time synchronization service');

    // 1. Listen for Global Time Info (0x202) - Usually once at boot
    final globalMapper = GlobalTimeInfoMapper();
    _globalTimeSub = _canManager.watchMessage(GlobalTimeInfoMapper.id).listen((frame) {
      try {
        final info = globalMapper.parse(frame.data);
        _currentInternalTime = info.toDateTime;
        _hasInitialDate = true;
        _logger.info('Global Time Anchor established', context: {
          'time': _currentInternalTime.toIso8601String(),
        });
        _emitIfChanged();
      } catch (e, st) {
        _logger.error('Failed to establish Global Time Anchor', error: e, stack: st);
      }
    });

    // 2. Listen for Time Sync (0x105) - 50Hz updates
    final syncMapper = CompTimeSyncMapper();
    _syncTimeSub = _canManager.watchMessage(CompTimeSyncMapper.id).listen((frame) {
      try {
        final sync = syncMapper.parse(frame.data);
        
        // Update only time portion, keep date from 0x202 (or now if not set)
        _currentInternalTime = DateTime(
          _currentInternalTime.year,
          _currentInternalTime.month,
          _currentInternalTime.day,
          sync.hour,
          sync.minute,
          sync.second,
          sync.millisecond,
        );
        
        _logger.verbose('System time synced via CAN 0x105');
        _emitIfChanged();
      } catch (e, st) {
        _logger.error('Time Sync (0x105) parse error', error: e, stack: st);
      }
    });

    // 3. Start local clock incrementer (every 10ms for high precision)
    // This ensures the clock keeps moving even if CAN messages pause.
    _localIncrementTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _currentInternalTime = _currentInternalTime.add(const Duration(milliseconds: 10));
      _emitIfChanged();
    });
  }

  void _emitIfChanged() {
    // Throttling: Only emit once per second to the UI
    if (_currentInternalTime.second != _lastEmittedSecond) {
      _lastEmittedSecond = _currentInternalTime.second;
      _timeCtrl.add(_currentInternalTime);
      _logger.debug('System clock tick', context: {
        'time': _currentInternalTime.toIso8601String().split('T').last,
      });
    }
  }

  void stop() {
    if (_localIncrementTimer == null) return;
    _logger.info('Stopping Global Time synchronization service');
    _localIncrementTimer?.cancel();
    _localIncrementTimer = null;
    _globalTimeSub?.cancel();
    _globalTimeSub = null;
    _syncTimeSub?.cancel();
    _syncTimeSub = null;
  }

  Stream<DateTime> watchTime() => _timeCtrl.stream;
  
  DateTime get currentTime => _currentInternalTime;
}
