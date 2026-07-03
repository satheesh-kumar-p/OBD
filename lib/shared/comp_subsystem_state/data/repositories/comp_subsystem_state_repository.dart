import 'dart:async';
import '../../../../core/comm/comm_manager.dart';
import '../../../../core/comm/can_bus/i_can_data_repository.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/comp_subsystem_state_entity.dart';
import '../mappers/comp_subsystem_state_mapper.dart';

class CompSubsystemStateRepository implements ICanDataRepository<CompSubsystemState> {
  final CommManager _canManager;
  final CanExtractionStrategy<CompSubsystemState> _mapper;
  final Logger _logger;

  final _ctrl = StreamController<CompSubsystemState>.broadcast();
  final _mapper = CompSubsystemStateMapper();
  StreamSubscription? _sub;

  CompSubsystemStateRepository({
    required CommManager canManager,
    required CanExtractionStrategy<CompSubsystemState> mapper,
    required Logger logger,
  }) : _canManager = canManager,
       _mapper = mapper,
       _logger = logger;

  @override
  Stream<CompSubsystemState?> watchCanData() {
    return _canManager.watchMessage(CompSubsystemState.id).map((frame) {
      if (frame == null) return null;

      try {
        return _mapper.parse(frame.data);
      } catch (e, st) {
        _logger.error('Failed to parse Radio State frame', error: e, stack: st);
        return null;
      }
    });
  }
