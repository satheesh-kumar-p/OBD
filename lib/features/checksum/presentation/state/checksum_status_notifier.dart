import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scout_obd/core/comm/checksum/checksum_status_mapper.dart';
import 'package:scout_obd/core/comm/checksum/checksum_status_entity.dart';
import 'package:scout_obd/core/comm/checksum/checksum_self_info_loader.dart';
import 'package:scout_obd/core/di/injection_container.dart';

/// Holds the latest decoded [ChecksumStatusEntity] per reporting app,
/// keyed by [ChecksumStatusEntity.sourceKey].
///
/// The wire feed is a heartbeat: each packet is a single envelope
/// covering multiple apps at once (e.g. telemetry/atlas/vision), sent
/// periodically. Rather than an ever-growing log, the UI wants "current
/// known status of each app" — so this keeps a map, updating in place
/// per key, mirroring how subsystem providers elsewhere in this project
/// hold a single latest entity rather than a history.
///
/// This app's own build identity (from [ChecksumSelfInfoLoader]) is
/// seeded into the initial state, so it shows up as a row alongside the
/// UDP-received entries without needing to send itself a packet.
class ChecksumStatusNotifier
    extends Notifier<Map<String, ChecksumStatusEntity>> {
  @override
  Map<String, ChecksumStatusEntity> build() {
    final self = ChecksumSelfInfoLoader.load();//to get the build info(takes the data coming form the ChecksumSelfInfoLoader and build the  )
    final initialState = self == null   //if the entry is null returns null
        ? <String, ChecksumStatusEntity>{}
        : {self.sourceKey: self};   // if entry exist it will populate the initial map with single entry with the key as the identifier (app name), ensures that apps own status is displayed befor any udp packets come

    ref.listen(checksumPacketsProvider, (_, next) {     // this listens to the data comming from the com_mannager.dart through the bridge checksum_provider.dart 
      next.whenData((packet) {    //next is the variable to catch the newly comming data
        final statuses = ChecksumStatusMapper.fromBytes(       // from byts send to the checksum_mapper.dart to map the raw data
          packet.data,
          receivedAt: packet.timestamp,
        );
        if (statuses.isEmpty) return;

        final updated = {...state};
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
    NotifierProvider<ChecksumStatusNotifier, Map<String, ChecksumStatusEntity>>(
      ChecksumStatusNotifier.new,
    );

/// Optional companion: a capped chronological log of every decoded
/// packet (not just the latest per app), for a DEBUG-tab-style scrolling
/// list view. Capped at 200 entries, matching the existing debug log
/// convention in this project. Not watched by default — only pull this
/// in if the screen wants a raw scrolling feed alongside the status table.
class ChecksumStatusLogNotifier extends Notifier<List<ChecksumStatusEntity>> {
  static const _cap = 200;

  @override
  List<ChecksumStatusEntity> build() {
    return [];
  }
}

final checksumStatusLogNotifierProvider =
    NotifierProvider<ChecksumStatusLogNotifier, List<ChecksumStatusEntity>>(
      ChecksumStatusLogNotifier.new,
    );