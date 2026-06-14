import 'dart:async';

import '../mappers/mc_temp_volt_mapper.dart';
import '../../domain/entities/mc_temp_volt_entity.dart';
import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';

class McTempVoltRepository implements ICanDataRepository<McTempVoltEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _streamCtrl = StreamController<McTempVoltEntity>.broadcast();
  final _mapper = McTempVoltMapper();

  StreamSubscription? _subscription;

  McTempVoltRepository({
    required CanCommManager canManager,
    required Logger logger,
  })  : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_subscription != null) return;
    _logger.info('Starting MC Temp Volt data stream (CAN ID: 0x${_mapper.messageId.toRadixString(16).toUpperCase()})');

    _subscription = _canManager
        .watchMessage(_mapper.messageId)
        .listen(
          (frame) {
            try {
              final entity = _mapper.parse(frame.data);
              _streamCtrl.add(entity);
            } catch (e, st) {
              _logger.error('Failed to parse MC Temp Volt frame', error: e, stack: st);
            }
          },
          onError: (e, st) {
            _logger.error('CAN MC Temp Volt Stream Error', error: e, stack: st);
          },
        );
  }

  @override
  void stopCanData() {
    if (_subscription == null) return;
    _logger.info('Stopping MC Temp Volt data stream');
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Stream<McTempVoltEntity> watchCanData() {
    return _streamCtrl.stream;
  }
}
