import '../entities/ugv_mode_entity.dart';
import '../entities/ugv_system_entity.dart';

abstract interface class UgvSystemInfoRepository {
  Stream<UgvModeEntity> watchUgvMode(String linkId);

  Stream<UgvSystemEntity> watchUgvHealth(String linkId);

  void startUgvSystemInfo(String linkId);

  void stopUgvSystemInfo();
}