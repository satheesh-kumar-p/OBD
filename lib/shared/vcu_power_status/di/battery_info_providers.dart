import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/battery_info_mapper.dart';
import '../data/repositories/battery_info_repository_impl.dart';
import '../domain/entities/battery_info_entity.dart';

final batteryLoggerProvider = Provider<Logger>((ref) => Logger('BATTERY_INFO'));

final batteryMapperProvider = Provider<BatteryInfoMapper>((ref) => BatteryInfoMapper());

final batteryInfoRepoProvider = Provider<BatteryInfoRepositoryImpl>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(batteryMapperProvider);
  final logger = ref.read(batteryLoggerProvider);

  return BatteryInfoRepositoryImpl(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final batteryInfoProvider = StreamProvider<BatteryInfoEntity?>((ref) {
  final repository = ref.watch(batteryInfoRepoProvider);
  return repository.watchCanData();
});
