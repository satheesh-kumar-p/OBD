import '../../../../shared/domain/repositories/ugv_system_info_repository.dart';
import '../../domain/entities/health_status_entity.dart';

class WatchUgvHealthUseCase {
  final UgvSystemInfoRepository _repository;

  WatchUgvHealthUseCase(this._repository);

  Stream<HealthStatusEntity> call(String linkId) {
    _repository.startUgvSystemInfo(linkId);
    return _repository.watchUgvHealth(linkId);
  }
}