import '../../domain/entities/ugv_system_entity.dart';
import '../../../../shared/domain/repositories/ugv_system_info_repository.dart';

class WatchUgvHealthUseCase {
  final UgvSystemInfoRepository _repository;

  WatchUgvHealthUseCase(this._repository);

  Stream<UgvSystemEntity> call(String linkId) {
    _repository.startUgvSystemInfo(linkId);
    return _repository.watchUgvHealth(linkId);
  }
}