import 'dart:async';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/global_time_info_entity.dart';
import '../mappers/global_time_info_mapper.dart';

class GlobalTimeInfoRepository implements ICanDataRepository<GlobalTimeInfoEntity> {
  final CommManager _canManager;
  final Logger _logger;

  final _controller = StreamController<GlobalTimeInfoEntity>.broadcast();
  final _mapper = GlobalTimeInfoMapper();
  StreamSubscription? _subscription;

  GlobalTimeInfoRepository({
    required CommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_subscription != null) return;
    _logger.info('Starting Global Time Info data stream (CAN ID: 0x${_mapper.messageId.toRadixString(16).toUpperCase()})');

    _subscription = _canManager.watchMessage(_mapper.messageId).listen(
      (frame) {
        try {
          final entity = _mapper.parse(frame.data);
          _controller.add(entity);
        } catch (e, st) {
          _logger.error('Failed to parse Global Time Info frame', error: e, stack: st);
        }
      },
      onError: (e, st) {
        _logger.error('CAN Global Time Info Stream Error', error: e, stack: st);
      },
    );
  }

  @override
  void stopCanData() {
    if (_subscription == null) return;
    _logger.info('Stopping Global Time Info data stream');
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Stream<GlobalTimeInfoEntity> watchCanData() => _controller.stream;
}
