import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/battery_info_repository.dart';
import '../domain/entities/battery_info_entity.dart';

final batteryLoggerProvider = Provider<Logger>((ref) => Logger('BATTERY_INFO'));

final batteryInfoRepoProvider = Provider<BatteryInfoRepository>((ref) {
  final logger = ref.read(batteryLoggerProvider);
  final canManager = ref.watch(canManagerProvider);

  return BatteryInfoRepository(
    canManager: canManager,
    logger: logger,
  );
});

final batteryInfoProvider = StreamProvider<BatteryInfoEntity>((ref) {
  final repository = ref.watch(batteryInfoRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
