import '../../enums/subsystem_status_enum.dart';

class ComputeCommInfoEntity {
  final SubsystemStatus uhfRadio;
  final SubsystemStatus lBandRadio;
  final SubsystemStatus compute;

  ComputeCommInfoEntity({
    required this.uhfRadio,
    required this.lBandRadio,
    required this.compute,
  });

  @override
  String toString() {
    return 'ComputeCommInfo(uhf: $uhfRadio, lBand: $lBandRadio, compute: $compute)';
  }
}
