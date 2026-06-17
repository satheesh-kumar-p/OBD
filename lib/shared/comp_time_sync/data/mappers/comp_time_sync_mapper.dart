import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/comp_time_sync_entity.dart';

class CompTimeSyncMapper extends CanExtractionStrategy<CompTimeSyncEntity> {
  static const int id = 0x206;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'hour', startBit: 56, endBit: 63),
    const CanField<int>(name: 'minute', startBit: 48, endBit: 55),
    const CanField<int>(name: 'second', startBit: 40, endBit: 47),
    const CanField<int>(name: 'millisecond', startBit: 30, endBit: 39),
  ];

  @override
  CompTimeSyncEntity build(Map<String, dynamic> parsedValues) {
    return CompTimeSyncEntity(
      hour: parsedValues['hour'],
      minute: parsedValues['minute'],
      second: parsedValues['second'],
      millisecond: parsedValues['millisecond'],
    );
  }
}
