import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scout_obd/core/comm/checksum/checksum_status_mapper.dart';
import 'package:scout_obd/core/comm/checksum/checksum_status_entity.dart';
import 'package:scout_obd/core/comm/checksum/checksum_self_info_loader.dart';
import 'package:scout_obd/core/di/injection_container.dart';

/// Holds the latest checksum status for each application.
///
/// The map contains:
///
///   SCOUT-OBD        -> this application's own status
///   telematics_server -> UDP status
///   ATLAS             -> UDP status
///   VISION            -> UDP status
///
/// Each application is identified by its appName.
class ChecksumStatusNotifier
    extends Notifier<Map<String, ChecksumStatusEntity>> {
  @override
  Map<String, ChecksumStatusEntity> build() {
    // --------------------------------------------------------------
    // Load this application's own build information.
    //
    // This now obtains:
    //
    //   appName  -> compile-time APP_NAME
    //   version  -> compile-time APP_VERSION
    //   checksum -> Docker RepoDigest
    //
    // The result is already a ChecksumStatusEntity.
    // --------------------------------------------------------------
    final self = ChecksumSelfInfoLoader.load();

    final initialState = self == null
        ? <String, ChecksumStatusEntity>{}
        : <String, ChecksumStatusEntity>{
            self.sourceKey: self,
          };

    // --------------------------------------------------------------
    // Listen for checksum packets received over UDP.
    // --------------------------------------------------------------
    ref.listen(checksumPacketsProvider, (_, next) {
      next.whenData((packet) {
        final statuses = ChecksumStatusMapper.fromBytes(
          packet.data,
          receivedAt: packet.timestamp,
        );

        if (statuses.isEmpty) {
          return;
        }

        // Start with the current state.
        final updated = {...state};

        // Update/add each application received through UDP.
        for (final status in statuses) {
          updated[status.sourceKey] = status;
        }

        state = updated;
      });
    });

    return initialState;
  }
}

final checksumStatusNotifierProvider =
    NotifierProvider<
      ChecksumStatusNotifier,
      Map<String, ChecksumStatusEntity>
    >(
      ChecksumStatusNotifier.new,
    );