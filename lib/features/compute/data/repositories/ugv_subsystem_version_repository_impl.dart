import 'dart:async';

import 'package:mavlink_module/dialects/ugvcustom.dart';

import '../../../../core/comm/comm_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/repositories/ugv_subsystem_version_repository.dart';
import '../models/ugv_subsystem_version_model.dart';

const int _kUgvSubsystemVersionMessageId = 50003;

class UgvSubsystemVersionRepositoryImpl
    implements UgvSubsystemVersionRepository {
  final CommManager _commManager;
  final Logger _logger;

  UgvSubsystemVersionRepositoryImpl({
    required CommManager commManager,
    required Logger logger,
  })  : _commManager = commManager,
        _logger = logger;

  @override
  Future<List<UgvSubsystemVersionModel>> requestSubsystemVersions({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final List<UgvSubsystemVersionModel> results = [];
    final completer = Completer<List<UgvSubsystemVersionModel>>();
    final Set<int> receivedTypes = {};

    final sub = _commManager
        .watchMessage(
      linkId: AppConstants.primaryLinkId,
      messageId: _kUgvSubsystemVersionMessageId,
    )
        .where((f) => f.systemId == AppConstants.ugvSystemId)
        .listen((frame) {
      try {
        final msg = frame.message as UgvSubsystemVersion;

        final model = UgvSubsystemVersionModel(
          type: msg.type,
          component1Sw: msg.component1Sw,
          component2Sw: msg.component2Sw,
          component3Sw: msg.component3Sw,
          component4Sw: msg.component4Sw,
          component5Sw: msg.component5Sw,
          component1Checksum: msg.component1Checksum.toList(),
          component2Checksum: msg.component2Checksum.toList(),
          component3Checksum: msg.component3Checksum.toList(),
          component4Checksum: msg.component4Checksum.toList(),
          component5Checksum: msg.component5Checksum.toList(),
        );

        _logger.info(
          'UGV_SUBSYSTEM_VERSION: decoded model',
          context: {
            'type': model.type,
            'component1Sw': model.component1Sw,
            'component1Checksum.count': model.component1Checksum.length,
            'receivedTypes': receivedTypes.toList(),
          },
        );

        if (!receivedTypes.contains(msg.type)) {
          receivedTypes.add(msg.type);
          results.add(model);
        }

        // We expect type 2 (SW) and type 3 (HW)
        if (receivedTypes.contains(2) && receivedTypes.contains(3)) {
          if (!completer.isCompleted) {
            completer.complete(results);
          }
        }
      } catch (err) {
        _logger.error('Error parsing UgvSubsystemVersion', error: err);
      }
    }, onError: (err) {
      if (!completer.isCompleted) {
        completer.completeError(err);
      }
    });

    // Send requests for both Software (2) and Hardware (3)
    for (final type in [2, 3]) {
      final cmd = CommandLong(
        targetSystem: AppConstants.ugvSystemId,
        targetComponent: AppConstants.ugvComponentId,
        command: 512, // MAV_CMD_REQUEST_MESSAGE
        param1: _kUgvSubsystemVersionMessageId.toDouble(),
        param2: type.toDouble(),
        param3: 0,
        param4: 0,
        param5: 0,
        param6: 0,
        param7: 0,
        confirmation: 1,
      );

      try {
        await _commManager.send(
          linkId: AppConstants.primaryLinkId,
          message: cmd,
        );
        _logger.info('Sent version request', context: {'type': type});
      } catch (err) {
        _logger.error('Failed to send version request', context: {'type': type}, error: err);
      }
    }

    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        if (results.isNotEmpty) {
          // If we got at least one, return what we have
          completer.complete(results);
        } else {
          completer.completeError(
            TimeoutException('UgvSubsystemVersion response timeout after ${timeout.inSeconds}s'),
          );
        }
      }
    });

    try {
      final finalResults = await completer.future;
      return finalResults;
    } finally {
      timer.cancel();
      await sub.cancel();
    }
  }
}
