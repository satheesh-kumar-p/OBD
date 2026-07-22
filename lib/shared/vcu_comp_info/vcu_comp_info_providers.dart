import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import './data/vcu_comp_info_mapper.dart';
import './data/vcu_comp_info_repository.dart';
import './domain/vcu_comp_info_entity.dart';

final vcuCompInfoLoggerProvider = Provider<Logger>((ref) => Logger('COMP_INFO'));

final vcuCompInfoMapperProvider = Provider<VcuCompInfoMapper>((ref) {
  return VcuCompInfoMapper();
});

final vcuCompInfoRepositoryProvider = Provider<VcuCompInfoRepository>((ref) {
  return VcuCompInfoRepository(
    canManager: ref.watch(commManagerProvider),
    mapper: ref.watch(vcuCompInfoMapperProvider),
    logger: ref.watch(vcuCompInfoLoggerProvider),
  );
});

final vcuCompInfoStreamProvider = StreamProvider<VcuCompInfoEntity?>((ref) {
  return ref.watch(vcuCompInfoRepositoryProvider).watchCanData();
});
