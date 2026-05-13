import 'package:scout_obd/shared/domain/entities/system_time_entity.dart';
import 'package:scout_obd/shared/domain/entities/time_sync_entity.dart';

abstract interface class TimeSyncRepository {

  Stream<SystemTimeEntity> watchSystemTime();

  Stream<TimeSyncEntity> watchTimeSync();

  void startTimeSync();

  void stopTimeSync();
}
