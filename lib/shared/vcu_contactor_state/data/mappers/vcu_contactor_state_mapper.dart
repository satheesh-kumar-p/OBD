import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/vcu_contactor_state_entity.dart';
import '../../enums/contactor_state_enum.dart';

/// Mapper for VCU Contactor State Message (0x207)
class VcuContactorStateMapper extends CanExtractionStrategy<VcuContactorStateEntity> {
  static final int id = 0x207;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'dcDcActuation',
      startBit: 46,
      endBit: 46,
    ),
    const CanField<int>(
      name: 'dcDcFeedback',
      startBit: 45,
      endBit: 45,
    ),
    const CanField<int>(
      name: 'lvPduActuation',
      startBit: 44,
      endBit: 44,
    ),
    const CanField<int>(
      name: 'lvPduFeedback',
      startBit: 43,
      endBit: 43,
    ),
    const CanField<int>(
      name: 'lvBatteryActuation',
      startBit: 42,
      endBit: 42,
    ),
    const CanField<int>(
      name: 'lvBatteryFeedback',
      startBit: 41,
      endBit: 41,
    ),
    const CanField<int>(
      name: 'prechargeActuation',
      startBit: 40,
      endBit: 40,
    ),
    const CanField<int>(
      name: 'prechargeFeedback',
      startBit: 39,
      endBit: 39,
    ),
    const CanField<int>(
      name: 'motorControllerActuation',
      startBit: 38,
      endBit: 38,
    ),
    const CanField<int>(
      name: 'motorControllerFeedback',
      startBit: 37,
      endBit: 37,
    ),
  ];

  @override
  VcuContactorStateEntity build(Map<String, dynamic> values) {
    return VcuContactorStateEntity(
      dcDcFeedbackState: ContactorState.fromValue(values['dcDcFeedback']),
      lvPduFeedbackState: ContactorState.fromValue(values['lvPduFeedback']),
      lvBatteryFeedbackState: ContactorState.fromValue(values['lvBatteryFeedback']),
      prechargeFeedbackState: ContactorState.fromValue(values['prechargeFeedback']),
      motorControllerFeedbackState: ContactorState.fromValue(values['motorControllerFeedback']),
    );
  }
}
