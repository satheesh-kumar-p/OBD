import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mapper/system_info_mapper.dart';
import '../data/repositories/system_info_repository.dart';
import '../domain/entities/system_info_entity.dart';

final systemInfoLoggerProvider = Provider<Logger>((ref) => Logger('SYSTEM_INFO'));

final systemInfoMapperProvider = Provider<VcuSubsystemStateMapper>((ref) => VcuSubsystemStateMapper());

final systemInfoRepoProvider =
Provider<SystemInfoRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(systemInfoMapperProvider);
  final logger = ref.read(systemInfoLoggerProvider);

  return SystemInfoRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final systemInfoProvider =
StreamProvider<SystemInfoEntity?>((ref) {
  final repository = ref.watch(systemInfoRepoProvider);
  return repository.watchCanData();
});
