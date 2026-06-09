import 'dart:async';
import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../domain/entities/compute_radio_state_entity.dart';
import '../mappers/compute_radio_state_mapper.dart';

class ComputeRadioStateRepository implements ICanDataRepository<ComputeCommInfoEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _ctrl = StreamController<ComputeCommInfoEntity>.broadcast();
  final _mapper = ComputeRadioStateMapper();
  StreamSubscription? _sub;

  ComputeRadioStateRepository({
    required CanCommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_sub != null) return;
    _logger.info('Starting Compute & Comm Info data stream (CAN ID: 0x${ComputeRadioStateMapper.id.toRadixString(16).toUpperCase()})');

    _sub = _canManager.watchMessage(ComputeRadioStateMapper.id).listen((frame) {
      try {
        final entity = _mapper.parse(frame.data);
        _ctrl.add(entity);
        _logger.debug('Compute & Comm data received', context: {
          'uhf': entity.uhfRadio,
          'compute': entity.compute,
        });
      } catch (e, st) {
        _logger.error('Failed to parse Compute & Comm frame', error: e, stack: st);
      }
    }, onError: (e, st) {
      _logger.error('CAN Compute & Comm Info Stream Error', error: e, stack: st);
    });
  }

  @override
  void stopCanData() {
    if (_sub == null) return;
    _logger.info('Stopping Compute & Comm Info data stream');
    _sub?.cancel();
    _sub = null;
  }

  @override
  Stream<ComputeCommInfoEntity> watchCanData() => _ctrl.stream;
}
