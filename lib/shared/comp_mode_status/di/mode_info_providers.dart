import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/mode_info_repository.dart';
import '../domain/entities/mode_entity.dart';

final modeLoggerProvider = Provider<Logger>((ref) => Logger('MODE_INFO'));

final modeInfoRepoProvider = Provider<ModeInfoRepository>((ref) {
  final logger = ref.read(modeLoggerProvider);
  final canManager = ref.watch(commManagerProvider);

  return ModeInfoRepository(
    canManager: canManager,
    logger: logger,
  );
});

final modeInfoProvider = StreamProvider<ModeEntity>((ref) {
  final repository = ref.watch(modeInfoRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
