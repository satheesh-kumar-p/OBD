import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import './data/vcu_interface_health_mapper.dart';
import './data/vcu_interface_health_repository.dart';
import './domain/vcu_interface_health_entity.dart';

final vcuInterfaceHealthLoggerProvider = Provider<Logger>((ref) => Logger('VCU_INTERFACE'));

final vcuInterfaceHealthMapperProvider = Provider<VcuInterfaceHealthMapper>((ref) => VcuInterfaceHealthMapper());

final vcuInterfaceHealthRepoProvider = Provider<VcuInterfaceHealthRepository>((ref) {
  final canManager = ref.watch(commManagerProvider);
  final mapper = ref.watch(vcuInterfaceHealthMapperProvider);
  final logger = ref.read(vcuInterfaceHealthLoggerProvider);

  return VcuInterfaceHealthRepository(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});

final vcuInterfaceHealthProvider = StreamProvider<VcuInterfaceHealthEntity?>((ref) {
  final repository = ref.watch(vcuInterfaceHealthRepoProvider);
  return repository.watchCanData();
});
