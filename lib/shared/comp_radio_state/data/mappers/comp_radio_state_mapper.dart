import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../domain/entities/comp_radio_state_entity.dart';

class CompRadioStateMapper extends CanExtractionStrategy<CompRadioState> {
  static const int id = 0x20C;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'uhfRadio', startBit: 38, endBit: 39),
    const CanField<int>(name: 'lBandRadio', startBit: 36, endBit: 37),
  ];

  @override
  CompRadioState build(Map<String, dynamic> parsedValues) {
    return CompRadioState(
      uhfRadio: _toStatus(parsedValues['uhfRadio']),
      lBandRadio: _toStatus(parsedValues['lBandRadio']),
    );
  }

  SubsystemFaultState _toStatus(int value) {
    switch (value) {
      case 0:
        return SubsystemFaultState.unknown;
      case 1:
        return SubsystemFaultState.noFault;
      case 2:
        return SubsystemFaultState.faulty;
      default:
        return SubsystemFaultState.badValue;
    }
  }
}
