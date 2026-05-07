import 'package:scout_obd/shared/domain/entities/system_time_entity.dart';
import 'package:scout_obd/shared/domain/repositories/time_sync_repository.dart';

class WatchSystemTimeUseCase {
  const WatchSystemTimeUseCase(this._repository);

  final TimeSyncRepository _repository;

  Stream<SystemTimeEntity> call(String linkId) {
    return _repository.watchSystemTime().where(
          (entity) => entity.linkId == linkId,
    );
  }

}