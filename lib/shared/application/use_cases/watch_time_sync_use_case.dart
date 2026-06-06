import 'package:scout_obd/shared/domain/entities/time_sync_entity.dart';
import 'package:scout_obd/shared/domain/repositories/time_sync_repository.dart';

class WatchTimeSyncUseCase {
  const WatchTimeSyncUseCase(this._repository);

  final TimeSyncRepository _repository;

  Stream<TimeSyncEntity> call(String linkId) {
    _repository.startTimeSync();
    return _repository.watchTimeSync().where(
      (entity) => entity.linkId == linkId,
    );
  }
}
