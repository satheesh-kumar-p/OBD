import '../../domain/entities/handcontroller_status_entity.dart';
import '../../domain/repositories/handcontroller_status_repository.dart';

class WatchHandcontrollerStatusUseCase {
  WatchHandcontrollerStatusUseCase(this._repository);

  final HandcontrollerStatusRepository _repository;

  Stream<HandcontrollerStatusEntity> call(String linkId) {
    return _repository.watchStatus(linkId);
  }
}