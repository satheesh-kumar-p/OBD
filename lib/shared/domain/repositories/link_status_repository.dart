import 'package:scout_obd/shared/domain/entities/link_status_entity.dart';

abstract class LinkStatusRepository {
  Stream<LinkStatusEntity> watchLinkStatus(String linkId);
}