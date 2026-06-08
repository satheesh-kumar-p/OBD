import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/repositories/battery_info_repository_impl.dart';
import '../domain/entities/battery_info_entity.dart';

final batteryLoggerProvider = Provider<Logger>((ref) => Logger('BATTERY_INFO'));

final batteryInfoRepoProvider = Provider<BatteryInfoRepositoryImpl>((ref) {
  final logger = ref.read(batteryLoggerProvider);
  final canManager = ref.watch(canManagerProvider);

  return BatteryInfoRepositoryImpl(
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
