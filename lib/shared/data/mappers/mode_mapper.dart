import 'package:mavlink_module/dialects/ugvcustom.dart' hide ModeChangeReason;

import '../../domain/entities/mode_entity.dart';
import '../../enums/mode_enum.dart';

class ModeMapper {
  ModeMapper._();

  static ModeEntity toModeEntity(UgvSystemInfo data) {
    return ModeEntity(
      mainMode: MainMode.values.firstWhere(
            (e) => e.value == data.mainMode,
        orElse: () => MainMode.unknown,
      ),
      subMode: SubMode.values.firstWhere(
            (e) => e.value == data.subMode,
        orElse: () => SubMode.unknown,
      ),
      intendedMainMode: MainMode.values.firstWhere(
            (e) => e.value == data.intendedMainMode,
        orElse: () => MainMode.unknown,
      ),
      intendedSubMode: SubMode.values.firstWhere(
            (e) => e.value == data.intendedSubMode,
        orElse: () => SubMode.unknown,
      ),
      modeChangeReason: ModeChangeReason.values.firstWhere(
            (e) => e.value == data.modeChangeReason,
        orElse: () => ModeChangeReason.unknown,
      ),
    );
  }

}