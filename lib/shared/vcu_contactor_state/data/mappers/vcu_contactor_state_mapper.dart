import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/vcu_contactor_state_entity.dart';
import '../../enums/contactor_fault_enum.dart';

/// Mapper for VCU Contactor State Message (0x207)
class VcuContactorStateMapper extends CanExtractionStrategy<VcuContactorStateEntity> {
  static final int id = 0x207;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'preChargeContFault',
      startBit: 46,
      endBit: 46,
    ),
    const CanField<int>(
      name: 'mcContFault',
      startBit: 45,
      endBit: 45,
    ),
    const CanField<int>(
      name: 'ipDcDcContFault',
      startBit: 44,
      endBit: 44,
    ),
    const CanField<int>(
      name: 'hvChargeContFault',
      startBit: 43,
      endBit: 43,
    ),
    const CanField<int>(
      name: 'lvChargeContFault',
      startBit: 42,
      endBit: 42,
    ),
    const CanField<int>(
      name: 'opDcDcContFault',
      startBit: 41,
      endBit: 41,
    ),
  ];

  @override
  VcuContactorStateEntity build(Map<String, dynamic> values) {
    return VcuContactorStateEntity(
      preChargeContFault: ContactorState.fromInt(values['preChargeContFault']),
      mcContFault: ContactorState.fromInt(values['mcContFault']),
      ipDcDcContFault: ContactorState.fromInt(values['ipDcDcContFault']),
      hvChargeContFault: ContactorState.fromInt(values['hvChargeContFault']),
      lvChargeContFault: ContactorState.fromInt(values['lvChargeContFault']),
      opDcDcContFault: ContactorState.fromInt(values['opDcDcContFault']),
    );
  }
}
