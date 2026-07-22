/// An interface for repositories that provide a reactive stream of data
/// from the CAN bus (or any communication link).
abstract class ICanDataRepository<T> {
  /// Returns a stream of the parsed data entity.
  /// Emits [null] if the data source becomes stale or unavailable.
  Stream<T> watchCanData();
}
