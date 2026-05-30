class CompTimeSyncEntity {
  final int hour;
  final int minute;
  final int second;
  final int millisecond;

  CompTimeSyncEntity({
    required this.hour,
    required this.minute,
    required this.second,
    required this.millisecond,
  });

  @override
  String toString() {
    return 'CompTimeSyncEntity($hour:$minute:$second.$millisecond)';
  }
}
