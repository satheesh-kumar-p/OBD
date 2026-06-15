import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/comp_time_sync_entity.dart';
import '../mappers/comp_time_sync_mapper.dart';

class CompTimeSyncRepository implements ICanDataRepository<CompTimeSyncEntity> {
  final CommManager _canManager;
  final Logger _logger;

  final _controller = StreamController<CompTimeSyncEntity>.broadcast();
  final _mapper = CompTimeSyncMapper();
  StreamSubscription? _subscription;

  CompTimeSyncRepository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_subscription != null) return;
    _logger.info('Starting Comp Time Sync data stream (CAN ID: 0x${_mapper.messageId.toRadixString(16).toUpperCase()})');

    _subscription = _canManager.watchMessage(_mapper.messageId).listen(
      (frame) {
        try {
          final entity = _mapper.parse(frame.data);
          _controller.add(entity);
        } catch (e, st) {
          _logger.error('Failed to parse Comp Time Sync frame', error: e, stack: st);
        }
      },
      onError: (e, st) {
        _logger.error('CAN Comp Time Sync Stream Error', error: e, stack: st);
      },
    );
  }

  @override
  void stopCanData() {
    if (_subscription == null) return;
    _logger.info('Stopping Comp Time Sync data stream');
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Stream<CompTimeSyncEntity> watchCanData() => _controller.stream;
}
