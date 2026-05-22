import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:scout_obd/core/comm/comm_manager.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/constants/subsystem_list_constants.dart';

import '../../domain/entities/handcontroller_status_entity.dart';
import '../../domain/repositories/handcontroller_status_repository.dart';

const int _kMsgIdUgvSystemInfo = 50001;
const String _kHandcontrollerSubsystemKey = 'UHF Radio';

class HandcontrollerStatusRepositoryImpl implements HandcontrollerStatusRepository {
  HandcontrollerStatusRepositoryImpl({
    required CommManager commManager,
    required Logger logger,
  })  : _commManager = commManager,
        _logger = logger;

  final CommManager _commManager;
  final Logger _logger;

  @override
  Stream<HandcontrollerStatusEntity> watchStatus(String linkId) {
    final subsystemIndex = kSubsystems.indexOf(_kHandcontrollerSubsystemKey);
    if (subsystemIndex < 0) {
      _logger.warn(
        'HandcontrollerStatus: subsystem key not found in kSubsystems',
        context: {'key': _kHandcontrollerSubsystemKey},
      );
      return Stream.value(
        HandcontrollerStatusEntity(
          status: HandcontrollerStatus.unknown,
          receivedAt: DateTime.now(),
        ),
      );
    }

    return _commManager
        .watchMessage(linkId: linkId, messageId: _kMsgIdUgvSystemInfo)
        .where((frame) => frame.systemId == AppConstants.ugvSystemId)
        .map((frame) {
          final msg = frame.message as UgvSystemInfo;

          final status = _decodeSubsystemStatus(
            subsystemIndex: subsystemIndex,
            health1: msg.subsystemHealth1,
            health2: msg.subsystemHealth2,
            health3: msg.subsystemHealth3,
            health4: msg.subsystemHealth4,
          );

          return HandcontrollerStatusEntity(
            status: status,
            receivedAt: DateTime.now(),
          );
        })
        // Avoid UI churn if the status hasn't changed.
        .distinct((a, b) => a.status == b.status);
  }

  HandcontrollerStatus _decodeSubsystemStatus({
    required int subsystemIndex,
    required int health1,
    required int health2,
    required int health3,
    required int health4,
  }) {
    final group = subsystemIndex ~/ 4; // 4 subsystems per byte (2 bits each)
    final byte = switch (group) {
      0 => health1,
      1 => health2,
      2 => health3,
      _ => health4,
    };

    final startBit = (subsystemIndex % 4) * 2;
    final bits = (byte >> startBit) & 0x3;

    return switch (bits) {
      1 => HandcontrollerStatus.noCommunication,
      2 => HandcontrollerStatus.healthy,
      3 => HandcontrollerStatus.unhealthy,
      _ => HandcontrollerStatus.unknown,
    };
  }
}