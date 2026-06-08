import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/global_time_info_entity.dart';

class GlobalTimeInfoMapper extends CanExtractionStrategy<GlobalTimeInfoEntity> {
  static const int id = 0x202;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'year', startBit: 0, endBit: 6),
    const CanField<int>(name: 'month', startBit: 7, endBit: 10),
    const CanField<int>(name: 'date', startBit: 11, endBit: 15),
    const CanField<int>(name: 'hour', startBit: 16, endBit: 20),
    const CanField<int>(name: 'minute', startBit: 21, endBit: 26),
    const CanField<int>(name: 'second', startBit: 27, endBit: 32),
  ];

  @override
  GlobalTimeInfoEntity build(Map<String, dynamic> parsedValues) {
    return GlobalTimeInfoEntity(
      year: parsedValues['year'],
      month: parsedValues['month'],
      date: parsedValues['date'],
      hour: parsedValues['hour'],
      minute: parsedValues['minute'],
      second: parsedValues['second'],
    );
  }
}
