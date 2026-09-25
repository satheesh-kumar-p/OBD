import '../entities/checksum_status_entity.dart';

/// Domain-layer contract for the live checksum/version UDP stream.
/// The presentation layer depends ONLY on this abstraction — never on
/// the concrete data-layer implementation.
abstract class IChecksumStatusRepository {
  Stream<List<ChecksumStatusEntity>> watchStatuses();
}