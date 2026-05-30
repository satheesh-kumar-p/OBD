import 'dart:async';
import '../../../../core/comm/can_bus/can_comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../../../shared/domain/repositories/can_data_repository.dart';
import '../../domain/entities/compute_comm_info_entity.dart';
import '../mappers/compute_comm_info_mapper.dart';

class ComputeCommInfoRepository implements CanDataRepository<ComputeCommInfoEntity> {
  final CanCommManager _canManager;
  final Logger _logger;

  final _ctrl = StreamController<ComputeCommInfoEntity>.broadcast();
  final _mapper = ComputeCommInfoMapper();
  StreamSubscription? _sub;

  ComputeCommInfoRepository({
    required CanCommManager canManager,
    required Logger logger,
  }) : _canManager = canManager,
        _logger = logger;

  @override
  void startCanData() {
    if (_sub != null) return;
    _sub = _canManager.watchMessage(ComputeCommInfoMapper.id).listen((frame) {
      final entity = _mapper.parse(frame.data);
      _ctrl.add(entity);
    });
  }

  @override
  void stopCanData() {
    _sub?.cancel();
    _sub = null;
  }

  @override
  Stream<ComputeCommInfoEntity> watchCanData() => _ctrl.stream;
}
