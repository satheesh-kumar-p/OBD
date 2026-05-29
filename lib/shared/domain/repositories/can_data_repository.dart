abstract class CanDataRepository<T> {
  void startCanData();
  void stopCanData();
  Stream<T> watchCanData();
}