import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/mc_temp_volt_mapper.dart';
import '../data/repositories/mc_temp_volt_repository.dart';
import '../domain/entities/mc_temp_volt_entity.dart';

final mcTempVoltLoggerProvider = Provider<Logger>((ref) => Logger('MC_TEMP_VOLT'));

final mcTempVoltMapperProvider = Provider<McTempVoltMapper>((ref) => McTempVoltMapper());

final mcTempVoltRepoProvider =
Provider<McTempVoltRepository>((ref) {
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(mcTempVoltMapperProvider);
  final logger = ref.read(mcTempVoltLoggerProvider);

  return McTempVoltRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final mcTempVoltProvider =
StreamProvider<McTempVoltEntity?>((ref) {
  final repository = ref.watch(mcTempVoltRepoProvider);
  return repository.watchCanData();
});
