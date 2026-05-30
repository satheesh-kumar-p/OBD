import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../core/logger/logger.dart';
import '../data/repositories/global_time_info_repository.dart';

final globalTimeLoggerProvider = Provider<Logger>((ref) => Logger('TIME_SYNC'));

final globalTimeRepositoryProvider = Provider<GlobalTimeInfoRepository>((ref) {
  final canManager = ref.watch(canManagerProvider);
  final logger = ref.read(globalTimeLoggerProvider);
  
  return GlobalTimeInfoRepository(
    canManager: canManager,
    logger: logger,
  );
});

final globalTimeProvider = StreamProvider<DateTime>((ref) {
  final repository = ref.watch(globalTimeRepositoryProvider);
  
  repository.start();
  
  ref.onDispose(() {
    repository.stop();
  });
  
  return repository.watchTime();
});
