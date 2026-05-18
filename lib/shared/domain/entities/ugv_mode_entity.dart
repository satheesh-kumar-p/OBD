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
        orElse: () => UgvMainMode.unknown,
      ),
      subMode: UgvSubMode.values.firstWhere(
        (e) => e.value == dto.subMode,
        orElse: () => UgvSubMode.unknown,
      ),
      intendedMainMode: UgvMainMode.values.firstWhere(
        (e) => e.value == dto.intendedMainMode,
        orElse: () => UgvMainMode.unknown,
      ),
      intendedSubMode: UgvSubMode.values.firstWhere(
        (e) => e.value == dto.intendedSubMode,
        orElse: () => UgvSubMode.unknown,
      ),
      modeChangeReason: ModeChangeReason.values.firstWhere(
        (e) => e.value == dto.modeChangeReason,
        orElse: () => ModeChangeReason.unknown,
      ),
    );
  }
}
