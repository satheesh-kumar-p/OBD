import '../../../../core/enums/subsystem_status_enum.dart';

class CompRadioState {
  final SubsystemStatus uhfRadio;
  final SubsystemStatus lBandRadio;

  CompRadioState({
    required this.uhfRadio,
    required this.lBandRadio,
  });

  @override
  String toString() {
    return 'ComputeCommInfo(uhf: $uhfRadio, lBand: $lBandRadio)';
  }
}
