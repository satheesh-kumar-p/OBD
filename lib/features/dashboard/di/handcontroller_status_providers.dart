/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/core/logger/logger.dart';

import '../application/use_cases/handcontroller_status_use_case.dart';
import '../data/repositories/handcontroller_status_repository_impl.dart';
import '../domain/entities/handcontroller_status_entity.dart';
import '../domain/repositories/handcontroller_status_repository.dart';

final handcontrollerStatusLoggerProvider =
    Provider<Logger>((ref) => Logger('HANDCTRL_STATUS'));

final handcontrollerStatusRepositoryProvider =
    Provider<HandcontrollerStatusRepository>((ref) {
  final logger = ref.watch(handcontrollerStatusLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return HandcontrollerStatusRepositoryImpl(
    commManager: commManager,
    logger: logger,
  );
});

final watchHandcontrollerStatusUseCaseProvider =
    Provider<WatchHandcontrollerStatusUseCase>((ref) {
  final repo = ref.watch(handcontrollerStatusRepositoryProvider);
  return WatchHandcontrollerStatusUseCase(repo);
});

final handcontrollerStatusProvider =
    StreamProvider.family<HandcontrollerStatusEntity, String>((ref, linkId) {
  final useCase = ref.watch(watchHandcontrollerStatusUseCaseProvider);
  return useCase(linkId);
});
*/
