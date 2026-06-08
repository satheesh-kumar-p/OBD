import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/e_stop_info_repository.dart';
import '../domain/entities/e_stop_info_entity.dart';

final eStopLoggerProvider = Provider<Logger>((ref) => Logger('E_STOP_INFO'));

final eStopInfoRepoProvider = Provider<EStopInfoRepository>((ref) {
  final logger = ref.read(eStopLoggerProvider);
  final canManager = ref.watch(canManagerProvider);

  return EStopInfoRepository(
    canManager: canManager,
    logger: logger,
  );
});

final eStopInfoProvider = StreamProvider<EStopInfoEntity>((ref) {
  final repository = ref.watch(eStopInfoRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
