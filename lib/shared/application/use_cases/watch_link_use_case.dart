import 'package:scout_obd/shared/domain/entities/link_status_entity.dart';
import 'package:scout_obd/shared/domain/repositories/link_status_repository.dart';

class WatchLinkStatusUseCase {
  const WatchLinkStatusUseCase({required this.repository});
  final LinkStatusRepository repository;

  Stream<LinkStatusEntity> call(String linkId) {
    return repository.watchLinkStatus(linkId)
        .where((entity) => entity.linkId == linkId);
  }
}