import '../../../../shared/data/can_field.dart';
import '../../domain/entities/battery_info_entity.dart';

class BatteryInfoMapper extends CanExtractionStrategy<BatteryInfoEntity> {
  static final int id = 0x200;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    // Battery fields
    const CanField<int>(
      name: 'soc',
      startBit: 17,
      endBit: 24,
    ),
    CanField<double>(
      name: 'voltage',
      startBit: 25,
      endBit: 32,
      transformer: (value) => value / 10.0,
    ),
  ];

  @override
  BatteryInfoEntity build(Map<String, dynamic> parsedValues) {
    return BatteryInfoEntity(
      soc: parsedValues['soc'],
      voltage: parsedValues['voltage'],
    );
  }
}
