import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/mode_info_mapper.dart';
import '../data/repositories/mode_info_repository.dart';
import '../domain/entities/mode_entity.dart';

final modeLoggerProvider = Provider<Logger>((ref) => Logger('MODE_INFO'));

final modeMapperProvider = Provider<ModeInfoMapper>((ref) => ModeInfoMapper());

final modeInfoRepoProvider = Provider<ModeInfoRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(modeMapperProvider);
  final logger = ref.read(modeLoggerProvider);

  return ModeInfoRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final modeInfoProvider = StreamProvider<ModeEntity?>((ref) {
  final repository = ref.watch(modeInfoRepoProvider);
  return repository.watchCanData();
});
