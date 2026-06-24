import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/repositories/pdu_vcu_status_ch1_4_repository.dart';
import '../domain/entities/pdu_vcu_status_ch1_4_entity.dart';
import '../../../core/logger/logger.dart';

final pduCh1_4LoggerProvider = Provider<Logger>((ref) => Logger('PDU_CH1_4'));

final pduCh1_4RepoProvider = Provider<PduVcuStatusCh1_4Repository>((ref) {
  final logger = ref.read(pduCh1_4LoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return PduVcuStatusCh1_4Repository(
    canManager: commManager,
    logger: logger,
  );
});

final pduCh1_4Provider = StreamProvider<PduVcuStatusCh1_4Entity>((ref) {
  final repository = ref.watch(pduCh1_4RepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
