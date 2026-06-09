import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/compute_comm_info_repository.dart';
import '../domain/entities/compute_comm_info_entity.dart';

final computeCommLoggerProvider = Provider<Logger>((ref) => Logger('COMP_COMM_INFO'));

final computeCommInfoRepoProvider = Provider<ComputeCommInfoRepository>((ref) {
  final logger = ref.read(computeCommLoggerProvider);
  final canManager = ref.watch(canManagerProvider);
  return ComputeCommInfoRepository(canManager: canManager, logger: logger);
});

final computeCommInfoProvider = StreamProvider<ComputeCommInfoEntity>((ref) {
  final repository = ref.watch(computeCommInfoRepoProvider);
  repository.startCanData();
  ref.onDispose(() => repository.stopCanData());
  return repository.watchCanData();
});
