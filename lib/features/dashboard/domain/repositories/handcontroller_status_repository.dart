import '../entities/handcontroller_status_entity.dart';

abstract interface class HandcontrollerStatusRepository {
  Stream<HandcontrollerStatusEntity> watchStatus(String linkId);
}