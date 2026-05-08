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
  Future<UgvSubsystemVersionModel> requestSubsystemVersion({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    // 1. Set up the one‑time listener for UGV_SUBSYSTEM_VERSION (50003)
    final completer = Completer<UgvSubsystemVersionModel>();

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

        if (!completer.isCompleted) {
          completer.complete(model);
        }
      } on Exception catch (err) {
        if (!completer.isCompleted) {
          completer.completeError(err);
        }
      }
    }, onError: (err) {
      if (!completer.isCompleted) {
        completer.completeError(err);
      }
    });

    // 2. Send both COMMAND_LONGs (type 2 and 3) — you can tweak if you want only one
    final cmdSw = CommandLong(
      targetSystem: AppConstants.ugvSystemId,
      targetComponent: AppConstants.ugvComponentId,
      command: _kUgvSubsystemVersionMessageId,
      param1: 0,
      param2: 2,
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0,
      confirmation: 1,
    );

    final cmdHw = CommandLong(
      targetSystem: AppConstants.ugvSystemId,
      targetComponent: AppConstants.ugvComponentId,
      command: _kUgvSubsystemVersionMessageId,
      param1: 0,
      param2: 3,
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0,
      confirmation: 1,
    );

    Future<void> sendCmd(CommandLong cmd) async {
      try {
        await _commManager.send(
          linkId: AppConstants.primaryLinkId,
          message: cmd,
        );
      } catch (err) {
        _logger.error('UgvSubsystemVersionRepository: sendCommandLong failed', error: err);
      }
    }

    await Future.wait([sendCmd(cmdSw), sendCmd(cmdHw)]);

    // 3. Wait for the response (or timeout)
    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('UgvSubsystemVersion response timeout after ${timeout.inSeconds}s'),
        );
      }
    });

    final model = await completer.future;

    timer.cancel();
    await sub.cancel();

    return model;
  }
}