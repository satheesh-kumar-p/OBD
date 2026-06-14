import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/comp_radio_state_repository.dart';
import '../domain/entities/comp_radio_state_entity.dart';

final computeCommLoggerProvider = Provider<Logger>((ref) => Logger('COMP_COMM_INFO'));

final compRadioRepoProvider = Provider<CompRadioStateRepository>((ref) {
  final logger = ref.read(computeCommLoggerProvider);
  final canManager = ref.watch(canManagerProvider);
  return CompRadioStateRepository(canManager: canManager, logger: logger);
});

final compRadioStateProvider = StreamProvider<CompRadioState>((ref) {
  final repository = ref.watch(compRadioRepoProvider);
  repository.startCanData();
  ref.onDispose(() => repository.stopCanData());
  return repository.watchCanData();
});
