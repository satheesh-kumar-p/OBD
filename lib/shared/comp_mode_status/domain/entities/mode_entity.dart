import '../../enums/mode_enum.dart';

class ModeEntity {
  final MainMode mainMode;
  final HoldSubMode holdSubMode;

  final SpeedMode speedMode;
  final DriveMode driveMode;

  final bool armed;
  final bool headlightsOn;
  final bool frontFogLightsOn;
  final bool rearBrakeLightsOn;

  ModeEntity({
    required this.mainMode,
    required this.holdSubMode,
    required this.speedMode,
    required this.driveMode,
    required this.armed,
    required this.headlightsOn,
    required this.frontFogLightsOn,
    required this.rearBrakeLightsOn,
  });

  @override
  String toString() {
    return 'Mode(Main Mode: ${mainMode.label}, '
        'Hold Sub Mode: ${holdSubMode.label}, '
        'Drive Mode: $driveMode, '
        'Speed Mode: $speedMode, '
        'Armed: $armed, '
        'Head Lights: ${headlightsOn ? 'ON' : 'OFF'},'
        'Front Fog Lights: ${frontFogLightsOn ? 'ON' : 'OFF'}, '
        'Rear Brake Lights: ${rearBrakeLightsOn ? 'ON' : 'OFF'})';
  }
}
