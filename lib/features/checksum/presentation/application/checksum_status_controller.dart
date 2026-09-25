import 'dart:async';

import 'package:scout_obd/features/checksum/domain/entities/checksum_status_entity.dart';
import 'package:scout_obd/features/checksum/domain/repositories/i_checksum_self_info_repository.dart';
import 'package:scout_obd/features/checksum/domain/repositories/i_checksum_status_repository.dart';


class ChecksumStatusController {
  final IChecksumSelfInfoRepository _selfInfoRepository;
  final IChecksumStatusRepository _statusRepository;

  final _stateController = StreamController<List<ChecksumStatusEntity>>.broadcast();
  StreamSubscription<List<ChecksumStatusEntity>>? _subscription;
  List<ChecksumStatusEntity> _state = const [];

  ChecksumStatusController({
    required IChecksumSelfInfoRepository selfInfoRepository,
    required IChecksumStatusRepository statusRepository,
  })  : _selfInfoRepository = selfInfoRepository,
        _statusRepository = statusRepository {
    _init();
  } 

  /// Current snapshot, sorted.
  List<ChecksumStatusEntity> get state => _state;

  /// Emits a new snapshot every time it changes.
  Stream<List<ChecksumStatusEntity>> get stateStream => _stateController.stream;

  Future<void> _init() async {
    final self = await _selfInfoRepository.getSelfInfo();
    final initialMap = self == null
        ? <String, ChecksumStatusEntity>{}
        : <String, ChecksumStatusEntity>{self.sourceKey: self};
    _emit(_sortEntities(initialMap.values));

    _subscription = _statusRepository.watchStatuses().listen((statuses) {
      if (statuses.isEmpty) return;

      final map = {for (final entity in _state) entity.sourceKey: entity};
      for (final status in statuses) {
        map[status.sourceKey] = status;
      }
      _emit(_sortEntities(map.values));
    });
  }

  void _emit(List<ChecksumStatusEntity> entities) {
    _state = entities;
    _stateController.add(_state);
  }

  List<ChecksumStatusEntity> _sortEntities(Iterable<ChecksumStatusEntity> entities) =>
      entities.toList()..sort((a, b) => a.appName.compareTo(b.appName));

  /// Must be called when this controller is no longer needed.
  void dispose() {
    _subscription?.cancel();
    _stateController.close();
  }
}