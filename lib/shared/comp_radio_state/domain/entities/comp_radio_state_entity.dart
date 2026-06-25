import '../../../../core/enums/subsystem_fault_state_enum.dart';

class CompRadioState {
  final SubsystemFaultState uhfRadio;
  final SubsystemFaultState lBandRadio;

  CompRadioState({
    required this.uhfRadio,
    required this.lBandRadio,
  });

  @override
  String toString() {
    return 'ComputeCommInfo(uhf: $uhfRadio, lBand: $lBandRadio)';
  }
}
