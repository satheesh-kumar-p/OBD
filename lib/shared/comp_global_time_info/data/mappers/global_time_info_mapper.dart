import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/global_time_info_entity.dart';

class GlobalTimeInfoMapper extends CanExtractionStrategy<GlobalTimeInfoEntity> {
  static const int id = 0x202;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'year', startBit: 56, endBit: 63),
    const CanField<int>(name: 'month', startBit: 48, endBit: 55),
    const CanField<int>(name: 'date', startBit: 40, endBit: 47),
    const CanField<int>(name: 'hour', startBit: 32, endBit: 39),
    const CanField<int>(name: 'minute', startBit: 24, endBit: 31),
    const CanField<int>(name: 'second', startBit: 16, endBit: 23),
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
