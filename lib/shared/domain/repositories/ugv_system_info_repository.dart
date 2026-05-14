import 'package:scout_obd/features/system/domain/entities/health_status_entity.dart';

import '../entities/ugv_mode_entity.dart';

abstract interface class UgvSystemInfoRepository {
  Stream<UgvModeEntity> watchUgvMode(String linkId);

  Stream<HealthStatusEntity> watchUgvHealth(String linkId);

  void startUgvSystemInfo(String linkId);

  void stopUgvSystemInfo();
}