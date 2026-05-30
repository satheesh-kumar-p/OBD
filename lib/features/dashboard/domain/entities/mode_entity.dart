import '../../enums/mode_enum.dart';

class ModeEntity {
  final MainMode mainMode;
  final SubMode subMode;

  final SpeedMode speedMode;
  final DriveMode driveMode;

  final bool armed;
  final bool headlightsOn;
  final bool frontFogLightsOn;
  final bool rearBrakeLightsOn;

  ModeEntity({
    required this.mainMode,
    required this.subMode,
    required this.speedMode,
    required this.driveMode,
    required this.armed,
    required this.headlightsOn,
    required this.frontFogLightsOn,
    required this.rearBrakeLightsOn,
  });
}