/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/shared/application/use_cases/watch_link_use_case.dart';
import 'package:scout_obd/shared/data/repositories/link_status_repository_impl.dart';
import 'package:scout_obd/shared/domain/entities/link_status_entity.dart';
import 'package:scout_obd/shared/domain/repositories/link_status_repository.dart';

import '../../core/di/injection_container.dart';

final loggerProvider = Provider<Logger>((ref) {
  return Logger('LINK_STATUS');
});

final linkStatusRepositoryProvider = Provider<LinkStatusRepository>((ref) {
  final comm = ref.watch(commManagerProvider);
  final logger = ref.watch(loggerProvider);
  return LinkStatusRepositoryImpl(commManager: comm, logger: logger);
});

final linkStatusUseCaseProvider = Provider<WatchLinkStatusUseCase>((ref) {
  return WatchLinkStatusUseCase(repository: ref.watch(linkStatusRepositoryProvider));
});

final linkStatusProvider = StreamProvider.family<LinkStatusEntity, String>((ref, linkId) {
  final useCase = ref.watch(linkStatusUseCaseProvider);
  return useCase(linkId);
});
*/
