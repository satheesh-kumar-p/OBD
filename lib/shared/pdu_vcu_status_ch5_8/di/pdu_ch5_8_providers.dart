import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/repositories/pdu_vcu_status_ch5_8_repository.dart';
import '../domain/entities/pdu_vcu_status_ch5_8_entity.dart';
import '../../../core/logger/logger.dart';

final pduCh5_8LoggerProvider = Provider<Logger>((ref) => Logger('PDU_CH5_8'));

final pduCh5_8RepoProvider = Provider<PduVcuStatusCh5_8Repository>((ref) {
  final logger = ref.read(pduCh5_8LoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return PduVcuStatusCh5_8Repository(
    canManager: commManager,
    logger: logger,
  );
});

final pduCh5_8Provider = StreamProvider<PduVcuStatusCh5_8Entity>((ref) {
  final repository = ref.watch(pduCh5_8RepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
