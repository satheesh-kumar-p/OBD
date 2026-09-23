import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scout_obd/features/checksum/di/checksum_status_providers.dart';
import 'package:scout_obd/features/checksum/domain/entities/checksum_status_entity.dart';

/// Maintains the checksum screen's latest status for each application, sorted by app name.
class ChecksumStatusController
    extends Notifier<List<ChecksumStatusEntity>> {
  @override
  List<ChecksumStatusEntity> build() {
    final self = ref.watch(checksumSelfInfoProvider).value;

    final Map<String, ChecksumStatusEntity> initialMap = self == null
        ? <String, ChecksumStatusEntity>{}
        : <String, ChecksumStatusEntity>{self.sourceKey: self};

    // Listen to incoming stream updates and update state in a sorted order
    ref.listen(checksumStatusStreamProvider, (_, next) {
      next.whenData((statuses) {
        if (statuses.isEmpty) return;
        
        // Extract current items into a mutable map for updating
        final map = {
          for (final entity in state) entity.sourceKey: entity,
        };

        for (final status in statuses) {
          map[status.sourceKey] = status;
        }

        state = _sortEntities(map.values);
      });
    });

    return _sortEntities(initialMap.values);
  }

  /// Sorts entities alphabetically by app name
  List<ChecksumStatusEntity> _sortEntities(Iterable<ChecksumStatusEntity> entities) {
    return entities.toList()
      ..sort((a, b) => a.appName.compareTo(b.appName));
  }
}

final checksumStatusControllerProvider =
    NotifierProvider<
      ChecksumStatusController,
      List<ChecksumStatusEntity>
    >(ChecksumStatusController.new);