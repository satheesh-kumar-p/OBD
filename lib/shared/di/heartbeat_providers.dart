import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/data/repositories/heartbeat_repository_impl.dart';
import 'package:scout_obd/shared/domain/repositories/heartbeat_repository.dart';

final heartbeatLoggerProvider = Provider<Logger>((ref) => Logger('HEARTBEAT'));

final heartbeatRepositoryProvider = Provider<HeartbeatRepository>((ref) {
  final logger = ref.read(heartbeatLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return HeartbeatRepositoryImpl(
    commManager: commManager,
    logger: logger,
  );
});