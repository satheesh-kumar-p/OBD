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
    CanField<MainMode>(
      name: 'mainMode',
      startBit: 36,
      endBit: 39,
      transformer: (value) => MainMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => MainMode.unknown,
      ),
    ),

    CanField<HoldSubMode>(
      name: 'holdSubMode',
      startBit: 32,
      endBit: 35,
      transformer: (value) => HoldSubMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => HoldSubMode.unknown,
      ),
    ),

    CanField<SpeedMode>(
      name: 'speedMode',
      startBit: 28,
      endBit: 31,
      transformer: (value) => SpeedMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => SpeedMode.unknown,
      ),
    ),

    CanField<DriveMode>(
      name: 'driveMode',
      startBit: 24,
      endBit: 27,
      transformer: (value) => DriveMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => DriveMode.unknown,
      ),
    ),

    CanField<ArmStatus>(
      name: 'armStatus',
      startBit: 22,
      endBit: 23,
      transformer: (value) => ArmStatus.values.firstWhere(
            (e) => e.value == value,
        orElse: () => ArmStatus.unknown,
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
