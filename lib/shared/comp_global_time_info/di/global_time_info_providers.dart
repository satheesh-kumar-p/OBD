import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/global_time_info_repository.dart';
import '../domain/entities/global_time_info_entity.dart';

final globalTimeLoggerProvider = Provider<Logger>((ref) => Logger('GLOBAL_TIME'));

final globalTimeInfoRepoProvider = Provider<GlobalTimeInfoRepository>((ref) {
  final canManager = ref.watch(canManagerProvider);
  final logger = ref.read(globalTimeLoggerProvider);
  
  return GlobalTimeInfoRepository(
    canManager: canManager,
    logger: logger,
  );
});

final globalTimeInfoProvider = StreamProvider<GlobalTimeInfoEntity>((ref) {
  final repository = ref.watch(globalTimeInfoRepoProvider);
  
  repository.startCanData();
  
  ref.onDispose(() {
    repository.stopCanData();
  });
  
  return repository.watchCanData();
});
