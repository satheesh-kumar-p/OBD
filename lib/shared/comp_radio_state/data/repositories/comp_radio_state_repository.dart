import 'dart:async';
import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../domain/entities/comp_radio_state_entity.dart';
import '../mappers/comp_radio_state_mapper.dart';

class CompRadioStateRepository implements ICanDataRepository<CompRadioState> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _ctrl = StreamController<CompRadioState>.broadcast();
  final _mapper = CompRadioStateMapper();
  StreamSubscription? _sub;

  CompRadioStateRepository({
    required CanCommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_sub != null) return;
    _logger.info('Starting Compute & Comm Info data stream (CAN ID: 0x${CompRadioStateMapper.id.toRadixString(16).toUpperCase()})');

    _sub = _canManager.watchMessage(CompRadioStateMapper.id).listen((frame) {
      try {
        final entity = _mapper.parse(frame.data);
        _ctrl.add(entity);
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
  Stream<CompRadioState> watchCanData() => _ctrl.stream;
}
