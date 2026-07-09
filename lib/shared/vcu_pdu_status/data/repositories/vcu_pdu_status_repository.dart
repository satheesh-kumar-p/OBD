import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/vcu_pdu_status_entity.dart';

class VcuPduStatusRepository implements ICanDataRepository<VcuPduStatusEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<VcuPduStatusEntity> _mapper;
  final Logger _logger;

  VcuPduStatusRepository({
    required CommManager canManager,
    required CanExtractionStrategy<VcuPduStatusEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<VcuPduStatusEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse VCU PDU Status frame', error: e, stack: st);
        return null;
      }
    });
  }
}
