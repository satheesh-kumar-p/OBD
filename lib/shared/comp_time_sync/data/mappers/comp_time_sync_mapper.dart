import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/comp_time_sync_entity.dart';

// TODO: Write a repo for this separately instead of using comp_global_time_info.
// Any merging of messages gets done in features. Like dashboard in features will take care of combining both repositories
// and in the feature, logic gets handled on what to do with each repository, later the ultimate data is going to be consumed into UI.
class CompTimeSyncMapper extends CanExtractionStrategy<CompTimeSyncEntity> {
  static const int id = 0x206;

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
