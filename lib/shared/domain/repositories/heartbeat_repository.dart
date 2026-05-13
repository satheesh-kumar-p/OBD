import 'package:scout_obd/shared/domain/entities/heartbeat_entity.dart';

abstract interface class HeartbeatRepository {
  Stream<HeartbeatEntity> watchHeartbeat(String linkId);

  Stream<bool> isActive(String linkId);

  void startHeartbeat(String linkId);
  void stopHeartbeat();
}