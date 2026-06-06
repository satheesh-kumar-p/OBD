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
      mainMode: UgvMainMode.values.firstWhere(
            (e) => e.value == dto.mainMode,
      ),
      subMode: UgvSubMode.values.firstWhere(
            (e) => e.value == dto.subMode,
      ),
      intendedMainMode: UgvMainMode.values.firstWhere(
            (e) => e.value == dto.intendedMainMode,
      ),
      intendedSubMode: UgvSubMode.values.firstWhere(
            (e) => e.value == dto.intendedSubMode,
      ),
      modeChangeReason: ModeChangeReason.values.firstWhere(
            (e) => e.value == dto.modeChangeReason,
      ),
    );
  }
}