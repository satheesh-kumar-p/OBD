import '../../enums/mode_enum.dart';

class ModeEntity {
  final MainModeEnum mainMode;
  final HoldSubModeEnum holdSubMode;

  final SpeedModeEnum speedMode;
  final DriveModeEnum driveMode;

  final ArmStatusEnum armStatus;

  ModeEntity({
    required this.mainMode,
    required this.holdSubMode,
    required this.speedMode,
    required this.driveMode,
    required this.armStatus,
  });

  @override
  String toString() {
    return 'Mode(Main Mode: ${mainMode.label}, '
        'Hold Sub Mode: ${holdSubMode.label}, '
        'Drive Mode: ${driveMode.label}, '
        'Speed Mode: ${speedMode.label}, '
        'Arm Status: ${armStatus.label})';
  }
}
