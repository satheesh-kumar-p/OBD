import 'dart:async';
import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:mavlink_module/mavlink.dart';
import 'package:scout_obd/core/comm/comm_manager.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/features/compute/domain/repositories/ugv_component_version_repository.dart';

class UgvVersionRepositoryImpl implements UgvVersionRepository {
  final CommManager _commManager;
  final Logger _logger;

  StreamSubscription<MavlinkFrame>? _heartbeatSub;

  UgvVersionRepositoryImpl({
    required CommManager commManager,
    required Logger logger
  })  : _commManager = commManager,
        _logger = logger;

  @override
  Future<void> sendVersionOnFirstHeartbeat({
    required int softwareVersion,
    required List<int> checksum,
    required int targetSystem,
    required int targetComponent,
  }) async {

    // Subscribe to first heartbeat only
    await _commManager
        .watchMessage(linkId: AppConstants.primaryLinkId, messageId: 0) // heartbeat ID
        .where((f) => f.systemId == AppConstants.ugvSystemId)
        .first
        .then((_) {
      _sendVersion(softwareVersion, checksum, targetSystem, targetComponent);
      _logger.info('Version sent on first heartbeat');
    });
  }

  void _sendVersion(int sw, List<int> chk, int ts, int tc) {
    _commManager.send(
      linkId: AppConstants.primaryLinkId,
      message: UgvComponentVersion(

        softwareVersion: sw,
        checksum: chk,
        targetSystem: ts,
        targetComponent: tc,
      ),
    );
  }

  void dispose() {
    _heartbeatSub?.cancel();
    _logger.info('UgvVersionRepository disposed');
  }
}