import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/mode_entity.dart';
import '../../enums/mode_enum.dart';

class ModeInfoMapper extends CanExtractionStrategy<ModeEntity> {
  static final int id = 0x20B;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    CanField<MainModeEnum>(
      name: 'mainMode',
      startBit: 36,
      endBit: 39,
      transformer: (value) => MainModeEnum.values.firstWhere(
            (e) => e.value == value,
        orElse: () => MainModeEnum.unknown,
      ),
    ),

    CanField<HoldSubModeEnum>(
      name: 'holdSubMode',
      startBit: 32,
      endBit: 35,
      transformer: (value) => HoldSubModeEnum.values.firstWhere(
            (e) => e.value == value,
        orElse: () => HoldSubModeEnum.unknown,
      ),
    ),

    CanField<SpeedModeEnum>(
      name: 'speedMode',
      startBit: 28,
      endBit: 31,
      transformer: (value) => SpeedModeEnum.values.firstWhere(
            (e) => e.value == value,
        orElse: () => SpeedModeEnum.unknown,
      ),
    ),

    CanField<DriveModeEnum>(
      name: 'driveMode',
      startBit: 24,
      endBit: 27,
      transformer: (value) => DriveModeEnum.values.firstWhere(
            (e) => e.value == value,
        orElse: () => DriveModeEnum.unknown,
      ),
    ),

    CanField<ArmStatusEnum>(
      name: 'armStatus',
      startBit: 22,
      endBit: 23,
      transformer: (value) => ArmStatusEnum.values.firstWhere(
            (e) => e.value == value,
        orElse: () => ArmStatusEnum.unknown,
      ),
    )
  ];

  @override
  ModeEntity build(Map<String, dynamic> parsedValues) {
    return ModeEntity(
      mainMode: parsedValues['mainMode'],
      holdSubMode: parsedValues['holdSubMode'],
      speedMode: parsedValues['speedMode'],
      driveMode: parsedValues['driveMode'],
      armStatus: parsedValues['armStatus'],
    );
  }
}
