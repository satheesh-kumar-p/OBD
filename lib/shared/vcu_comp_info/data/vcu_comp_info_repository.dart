import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../domain/vcu_comp_info_entity.dart';

class VcuCompInfoRepository implements ICanDataRepository<VcuCompInfoEntity?> {
  final CommManager _canManager;
  final CanExtractionStrategy<VcuCompInfoEntity> _mapper;
  final Logger _logger;

  VcuCompInfoRepository({
    required CommManager canManager,
    required CanExtractionStrategy<VcuCompInfoEntity> mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<VcuCompInfoEntity?> watchCanData() {
    return _canManager.watchMessage(_mapper.messageId).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse VCU Compute Info frame', error: e, stack: st);
        return null;
      }
    });
  }
}
