import '../../data/models/ugv_system_info_model.dart';
import '../../enums/ugv_mode.dart';

class UgvModeEntity {
  final UgvMainMode mainMode;
  final UgvSubMode subMode;
  final UgvMainMode intendedMainMode;
  final UgvSubMode intendedSubMode;
  final ModeChangeReason modeChangeReason;

  UgvModeEntity({
    required this.mainMode,
    required this.subMode,
    required this.intendedMainMode,
    required this.intendedSubMode,
    required this.modeChangeReason,
  });

  factory UgvModeEntity.fromDto(UgvSystemInfoModel dto) {
    return UgvModeEntity(
      mainMode: UgvMainMode.values[dto.mainMode],
      subMode: UgvSubMode.values.elementAt(UgvSubMode.values.indexWhere((e) => e.value == dto.subMode)),
      intendedMainMode: UgvMainMode.values[dto.intendedMainMode],
      intendedSubMode: UgvSubMode.values.elementAt(UgvSubMode.values.indexWhere((e) => e.value == dto.intendedSubMode)),
      modeChangeReason: ModeChangeReason.values[dto.modeChangeReason],
    );
  }
}