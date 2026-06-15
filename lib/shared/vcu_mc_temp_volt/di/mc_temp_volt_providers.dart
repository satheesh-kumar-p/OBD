import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/repositories/mc_temp_volt_repository.dart';
import '../domain/entities/mc_temp_volt_entity.dart';
import '../../../core/logger/logger.dart';

final mcTempVoltLoggerProvider =
Provider<Logger>((ref) => Logger('MC_TEMP_VOLT'));

final mcTempVoltRepoProvider =
Provider<McTempVoltRepository>((ref) {
  final logger = ref.read(mcTempVoltLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return McTempVoltRepository(
    canManager: commManager,
    logger: logger,
  );
});

final mcTempVoltProvider =
StreamProvider<McTempVoltEntity>((ref) {
  final repository = ref.watch(mcTempVoltRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
