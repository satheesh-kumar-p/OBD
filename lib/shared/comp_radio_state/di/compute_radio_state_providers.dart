import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/compute_radio_state_repository.dart';
import '../domain/entities/compute_radio_state_entity.dart';

final computeCommLoggerProvider = Provider<Logger>((ref) => Logger('COMP_COMM_INFO'));

final computeRadioRepoProvider = Provider<ComputeRadioStateRepository>((ref) {
  final logger = ref.read(computeCommLoggerProvider);
  final canManager = ref.watch(canManagerProvider);
  return ComputeRadioStateRepository(canManager: canManager, logger: logger);
});

final computeRadioStateProvider = StreamProvider<ComputeCommInfoEntity>((ref) {
  final repository = ref.watch(computeRadioRepoProvider);
  repository.startCanData();
  ref.onDispose(() => repository.stopCanData());
  return repository.watchCanData();
});
