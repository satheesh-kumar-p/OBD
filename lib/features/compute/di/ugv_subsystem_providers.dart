/*
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../application/use_cases/request_ugv_subsystem_version_use_case.dart';
import '../data/models/ugv_subsystem_version_model.dart';
import '../data/repositories/ugv_subsystem_version_repository_impl.dart';
import '../domain/repositories/ugv_subsystem_version_repository.dart';

final ugvSubsystemVersionLoggerProvider = Provider<Logger>(
      (ref) => Logger('UGV_SUBSYSTEM_VERSION'),
);

// ─────────────────────────────
// 2. Repository
// ─────────────────────────────

final ugvSubsystemVersionRepositoryProvider = Provider<UgvSubsystemVersionRepository>(
      (ref) {
    final logger = ref.watch(ugvSubsystemVersionLoggerProvider);
    final commManager = ref.watch(commManagerProvider);

    return UgvSubsystemVersionRepositoryImpl(
      commManager: commManager,
      logger: logger,
    );
  },
);

// ─────────────────────────────
// 3. Use‑case (for request–response pattern)
// ─────────────────────────────

final requestUgvVersionsUseCaseProvider = Provider<RequestUgvVersionsUseCase>(
      (ref) {
    final repository = ref.watch(ugvSubsystemVersionRepositoryProvider);
    return RequestUgvVersionsUseCase(repository);
  },
);

// One‑shot FutureProvider for the version page
final ugvVersionsProvider = FutureProvider<List<UgvSubsystemVersionModel>>((ref) {
    final useCase = ref.watch(requestUgvVersionsUseCaseProvider);
    return useCase();
  },
);
*/
