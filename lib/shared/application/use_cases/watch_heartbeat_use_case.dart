import 'package:scout_obd/shared/domain/entities/heartbeat_entity.dart';
import 'package:scout_obd/shared/domain/repositories/heartbeat_repository.dart';

class WatchHeartbeatUseCase {
  const WatchHeartbeatUseCase(this._repository);

  final HeartbeatRepository _repository;

  Stream<HeartbeatEntity> call(String linkId) {
    _repository.startHeartbeat(linkId);
    return _repository.watchHeartbeat(linkId);
  }
}
