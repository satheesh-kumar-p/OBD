import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/mappers/vcu_pdu_status_mapper.dart';
import '../data/repositories/vcu_pdu_status_repository.dart';
import '../domain/entities/vcu_pdu_status_entity.dart';
import '../../../core/logger/logger.dart';

final vcuPduLoggerProvider = Provider<Logger>((ref) => Logger('VCU_PDU'));

final vcuPduStatusMapperProvider = Provider<VcuPduStatusMapper>((ref) => VcuPduStatusMapper());

final vcuPduStatusRepoProvider = Provider<VcuPduStatusRepository>((ref) {
  final logger = ref.read(vcuPduLoggerProvider);
  final commManager = ref.watch(commManagerProvider);
  final mapper = ref.read(vcuPduStatusMapperProvider);

  return VcuPduStatusRepository(
    canManager: commManager,
    mapper: mapper,
    logger: logger,
  );
});

final vcuPduStatusProvider = StreamProvider<VcuPduStatusEntity?>((ref) {
  final repository = ref.watch(vcuPduStatusRepoProvider);
  return repository.watchCanData();
});
