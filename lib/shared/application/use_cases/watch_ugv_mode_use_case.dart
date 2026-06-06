import 'package:scout_obd/shared/domain/repositories/ugv_system_info_repository.dart';

import '../../domain/entities/ugv_mode_entity.dart';

class WatchUgvModeUseCase {
  final UgvSystemInfoRepository _repository;

  WatchUgvModeUseCase(this._repository);

  Stream<UgvModeEntity> call(String linkId) {
    _repository.startUgvSystemInfo(linkId);
    return _repository.watchUgvMode(linkId);
  }
}