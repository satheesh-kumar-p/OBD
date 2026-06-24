import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/repositories/vcu_pdu_status_repository.dart';
import '../domain/entities/vcu_pdu_status_entity.dart';
import '../../../core/logger/logger.dart';

final vcuPduLoggerProvider = Provider<Logger>((ref) => Logger('VCU_PDU'));

final vcuPduStatusRepoProvider = Provider<VcuPduStatusRepository>((ref) {
  final logger = ref.read(vcuPduLoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return VcuPduStatusRepository(
    canManager: commManager,
    logger: logger,
  );
});

final vcuPduStatusProvider = StreamProvider<VcuPduStatusEntity>((ref) {
  final repository = ref.watch(vcuPduStatusRepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
