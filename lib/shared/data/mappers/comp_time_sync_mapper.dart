import '../../domain/entities/comp_time_sync_entity.dart';
import '../can_field.dart';

class CompTimeSyncMapper extends CanExtractionStrategy<CompTimeSyncEntity> {
  static const int id = 0x105;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'hour', startBit: 0, endBit: 4),
    const CanField<int>(name: 'minute', startBit: 5, endBit: 10),
    const CanField<int>(name: 'second', startBit: 11, endBit: 16),
    const CanField<int>(name: 'millisecond', startBit: 17, endBit: 26),
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
