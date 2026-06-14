abstract class ICanDataRepository<T> {
  void startCanData();
  void stopCanData();
  Stream<T> watchCanData();
}