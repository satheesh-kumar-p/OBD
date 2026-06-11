import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/battery_info_entity.dart';

class BatteryInfoMapper extends CanExtractionStrategy<BatteryInfoEntity> {
  static final int id = 0x200;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    // Battery fields
    const CanField<int>(
      name: 'hvBatterySoc',
      startBit: 32,
      endBit: 39,
    ),
    CanField<int>(
      name: 'lvBatterySoc',
      startBit: 24,
      endBit: 31,
    ),
  ];

  @override
  BatteryInfoEntity build(Map<String, dynamic> parsedValues) {
    return BatteryInfoEntity(
      hvBatterySoc: parsedValues['hvBatterySoc'],
      lvBatterySoc: parsedValues['lvBatterySoc'],
    );
  }
}
