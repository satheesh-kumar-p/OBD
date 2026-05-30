import '../../../../shared/data/can_field.dart';
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
      startBit: 17,
      endBit: 20,
      transformer: (value) => MainMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => MainMode.unknown,
      ),
    ),

    CanField<SubMode>(
      name: 'subMode',
      startBit: 21,
      endBit: 24,
      transformer: (value) => SubMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => SubMode.unknown,
      ),
    ),

    CanField<SpeedMode>(
      name: 'speedMode',
      startBit: 25,
      endBit: 28,
      transformer: (value) => SpeedMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => SpeedMode.unknown,
      ),
    ),

    CanField<DriveMode>(
      name: 'driveMode',
      startBit: 29,
      endBit: 32,
      transformer: (value) => DriveMode.values.firstWhere(
            (e) => e.value == value,
        orElse: () => DriveMode.unknown,
      ),
    ),

    CanField<bool>(
      name: 'armed',
      startBit: 33,
      endBit: 33,
      transformer: (value) => value == 1,
    ),

    CanField<bool>(
      name: 'headlightsOn',
      startBit: 34,
      endBit: 34,
      transformer: (value) => value == 1,
    ),

    CanField<bool>(
      name: 'frontFogLightsOn',
      startBit: 35,
      endBit: 35,
      transformer: (value) => value == 1,
    ),

    CanField<bool>(
      name: 'rearBrakeLightsOn',
      startBit: 36,
      endBit: 36,
      transformer: (value) => value == 1,
    ),
  ];

  @override
  ModeEntity build(Map<String, dynamic> parsedValues) {
    return ModeEntity(
      mainMode: parsedValues['mainMode'],
      subMode: parsedValues['subMode'],
      speedMode: parsedValues['speedMode'],
      driveMode: parsedValues['driveMode'],
      armed: parsedValues['armed'],
      headlightsOn: parsedValues['headlightsOn'],
      frontFogLightsOn: parsedValues['frontFogLightsOn'],
      rearBrakeLightsOn: parsedValues['rearBrakeLightsOn'],
    );
  }
}