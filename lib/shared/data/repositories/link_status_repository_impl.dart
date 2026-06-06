import 'dart:async';
import 'package:scout_obd/core/comm/comm_manager.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/domain/entities/link_status_entity.dart';
import 'package:scout_obd/shared/domain/repositories/link_status_repository.dart';

class LinkStatusRepositoryImpl implements LinkStatusRepository {
  final CommManager _commManager;
  final Logger _logger;

  LinkStatusRepositoryImpl({
    required CommManager commManager,
    required Logger logger,
  }) : _commManager = commManager, _logger = logger;

  @override
  Stream<LinkStatusEntity> watchLinkStatus(String linkId) {
    // Relying on single-subscription stream buffering to handle startup events.
    return _commManager.watchConnectionStatus(linkId).map(
      (connected) => LinkStatusEntity(linkId: linkId, isConnected: connected),
    );
  }
}
