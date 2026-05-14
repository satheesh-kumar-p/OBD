import '../../../features/system/domain/entities/health_status_entity.dart';
import '../../../features/system/enums/subsystem_status_enum.dart';
import '../../constants/subsystem_list_constants.dart';
import '../../domain/entities/ugv_mode_entity.dart';
import '../../enums/ugv_mode.dart';

class UgvSystemInfoModel {
  final int subsystemHealth1;
  final int subsystemHealth2;
  final int subsystemHealth3;
  final int subsystemHealth4;
  final int mainMode;
  final int subMode;
  final int batterySoc;
  final int intendedMainMode;
  final int intendedSubMode;
  final int modeChangeReason;

  UgvSystemInfoModel({
    required this.subsystemHealth1,
    required this.subsystemHealth2,
    required this.subsystemHealth3,
    required this.subsystemHealth4,
    required this.mainMode,
    required this.subMode,
    required this.batterySoc,
    required this.intendedMainMode,
    required this.intendedSubMode,
    required this.modeChangeReason,
  });

  HealthStatusEntity toHealthStatusEntity() {
    return HealthStatusEntity(_parseSubsystemHealth());
  }

  UgvModeEntity toModeEntity() {
    return UgvModeEntity(
      mainMode: UgvMainMode.values.firstWhere(
            (e) => e.value == mainMode,
      ),
      subMode: UgvSubMode.values.firstWhere(
            (e) => e.value == subMode,
      ),
      intendedMainMode: UgvMainMode.values.firstWhere(
            (e) => e.value == intendedMainMode,
      ),
      intendedSubMode: UgvSubMode.values.firstWhere(
            (e) => e.value == intendedSubMode,
      ),
      modeChangeReason: ModeChangeReason.values.firstWhere(
            (e) => e.value == modeChangeReason,
      ),
    );
  }

  Map<String, SubsystemStatus> _parseSubsystemHealth() {
    final result = <String, SubsystemStatus>{};
    var currentByte = subsystemHealth1;

    for (int i = 0; i < kSubsystems.length; i++) {
      final startBit = (i * 2) % 8;
      final extractedBits = (currentByte >> startBit) & 0x3;
      result[kSubsystems[i]] = _statusFromBits(extractedBits);

      if (i % 4 == 3 && i < kSubsystems.length - 1) {
        currentByte =
        i < 4 ? subsystemHealth2 : i < 8 ? subsystemHealth3 : subsystemHealth4;
      }
    }

    return result;
  }

  SubsystemStatus _statusFromBits(int bits) {
    switch(bits) {
      case 1: return SubsystemStatus.noCommunication;
      case 2: return SubsystemStatus.healthy;
      case 3: return SubsystemStatus.unhealthy;
      default: throw ArgumentError('Unknown Value for Subsystem Status: $bits');
    }
  }

}
