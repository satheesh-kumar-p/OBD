import 'package:scout_obd/shared/domain/repositories/ugv_system_info_repository.dart';

import '../../domain/entities/mode_entity.dart';

class WatchUgvModeUseCase {
  final UgvSystemInfoRepository _repository;

  WatchUgvModeUseCase(this._repository);

  Stream<ModeEntity> call() {
    _repository.startUgvSystemInfo();
    return _repository.watchUgvMode();
  }
}