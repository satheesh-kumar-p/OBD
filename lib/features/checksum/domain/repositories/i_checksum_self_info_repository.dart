import '../entities/checksum_status_entity.dart';

/// Domain-layer contract for this app's own build/version identity.
abstract class IChecksumSelfInfoRepository {
  Future<ChecksumStatusEntity?> getSelfInfo();
}