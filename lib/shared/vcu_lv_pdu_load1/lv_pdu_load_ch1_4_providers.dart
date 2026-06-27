import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/shared/vcu_lv_pdu_load1/domain/entities/lv_pdu_load_ch1_4_entity.dart';
import '../../core/di/injection_container.dart';
import 'data/repositories/lv_pdu_load_ch1_4_repository.dart';
import '../../core/logger/logger.dart';

final pduCh1_4LoggerProvider = Provider<Logger>((ref) => Logger('PDU_CH1_4'));

final pduCh1_4RepoProvider = Provider<LvPduLoadCh14Repository>((ref) {
  final logger = ref.read(pduCh1_4LoggerProvider);
  final commManager = ref.watch(commManagerProvider);

  return LvPduLoadCh14Repository(
    canManager: commManager,
    logger: logger,
  );
});

final lvPduLoadCh1_4Provider = StreamProvider<LvPduLoadCh14Entity>((ref) {
  final repository = ref.watch(pduCh1_4RepoProvider);

  repository.startCanData();

  ref.onDispose(() {
    repository.stopCanData();
  });

  return repository.watchCanData();
});
