import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../domain/vcu_interface_health_entity.dart';

class VcuInterfaceHealthRepository implements ICanDataRepository<VcuInterfaceHealthEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<VcuInterfaceHealthEntity> _mapper;
  final Logger _logger;

  VcuInterfaceHealthRepository({
    required CommManager canManager,
    required CanExtractionStrategy<VcuInterfaceHealthEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<VcuInterfaceHealthEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse VCU Interface Health frame', error: e, stack: st);
        return null;
      }
    });
  }
}
