class GlobalTimeInfoEntity {
  final int year;
  final int month;
  final int date;
  final int hour;
  final int minute;
  final int second;

  GlobalTimeInfoEntity({
    required this.year,
    required this.month,
    required this.date,
    required this.hour,
    required this.minute,
    required this.second,
  });

  DateTime get toDateTime => DateTime(2000 + year, month, date, hour, minute, second);

  @override
  String toString() {
    return 'GlobalTimeInfoEntity($year-$month-$date $hour:$minute:$second)';
  }
}
