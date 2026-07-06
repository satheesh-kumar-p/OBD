import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mapper/e_stop_info_mapper.dart';
import '../data/repositories/e_stop_info_repository.dart';
import '../domain/entities/e_stop_info_entity.dart';

final eStopLoggerProvider = Provider<Logger>((ref) => Logger('E_STOP_INFO'));

final eStopMapperProvider = Provider<EStopInfoMapper>((ref) => EStopInfoMapper());

final eStopInfoRepoProvider = Provider<EStopInfoRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(eStopMapperProvider);
  final logger = ref.read(eStopLoggerProvider);

  return EStopInfoRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final eStopInfoProvider = StreamProvider<EStopInfoEntity?>((ref) {
  final repository = ref.watch(eStopInfoRepoProvider);
  return repository.watchCanData();
});
