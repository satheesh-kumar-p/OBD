import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/compute_comm_info_repository.dart';
import '../data/repositories/system_info_repository.dart';
import '../domain/entities/system_info_entity.dart';
import '../domain/entities/compute_comm_info_entity.dart';
import '../presentation/state/system_screen_state.dart';

final systemLoggerProvider =
Provider<Logger>((ref) => Logger('HEALTH'));

final systemInfoRepoProvider =
Provider<SystemInfoRepository>((ref) {
  final logger = ref.read(systemLoggerProvider);
  final canManager = ref.watch(canManagerProvider);

  return SystemInfoRepository(
    canManager: canManager,
    logger: logger,
  );
});

final systemInfoProvider =
StreamProvider<SystemInfoEntity>((ref) {
  final repository = ref.watch(systemInfoRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});

final computeCommInfoRepoProvider = Provider<ComputeCommInfoRepository>((ref) {
  final logger = ref.read(systemLoggerProvider);
  final canManager = ref.watch(canManagerProvider);
  return ComputeCommInfoRepository(canManager: canManager, logger: logger);
});

final computeCommInfoProvider = StreamProvider<ComputeCommInfoEntity>((ref) {
  final repository = ref.watch(computeCommInfoRepoProvider);
  repository.startCanData();
  ref.onDispose(() => repository.stopCanData());
  return repository.watchCanData();
});

final systemScreenStateProvider = Provider<SystemScreenState>((ref) {
  final systemInfo = ref.watch(systemInfoProvider).asData?.value;
  final computeInfo = ref.watch(computeCommInfoProvider).asData?.value;

  return SystemScreenState(
    systemInfo: systemInfo,
    computeCommInfo: computeInfo,
  );
});
