import '../../enums/mode_enum.dart';

class ModeEntity {
  final MainMode mainMode;
  final SubMode subMode;
  final MainMode intendedMainMode;
  final SubMode intendedSubMode;
  final ModeChangeReason modeChangeReason;

  ModeEntity({
    required this.mainMode,
    required this.subMode,
    required this.intendedMainMode,
    required this.intendedSubMode,
    required this.modeChangeReason,
  });

}
