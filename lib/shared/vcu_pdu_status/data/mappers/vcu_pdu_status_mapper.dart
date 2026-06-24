import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/vcu_pdu_status_entity.dart';

/// Mapper for VCU PDU Status Message (0x210)
class VcuPduStatusMapper extends CanExtractionStrategy<VcuPduStatusEntity> {
  static final int id = 0x210;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'channel1',
      startBit: 39,
      endBit: 39,
    ),
    const CanField<int>(
      name: 'channel2',
      startBit: 38,
      endBit: 38,
    ),
    const CanField<int>(
      name: 'channel3',
      startBit: 37,
      endBit: 37,
    ),
    const CanField<int>(
      name: 'channel4',
      startBit: 36,
      endBit: 36,
    ),
    const CanField<int>(
      name: 'channel5',
      startBit: 35,
      endBit: 35,
    ),
    const CanField<int>(
      name: 'channel6',
      startBit: 34,
      endBit: 34,
    ),
    const CanField<int>(
      name: 'channel7',
      startBit: 33,
      endBit: 33,
    ),
    const CanField<int>(
      name: 'channel8',
      startBit: 32,
      endBit: 32,
    ),
  ];

  @override
  VcuPduStatusEntity build(Map<String, dynamic> values) {
    return VcuPduStatusEntity(
      channel1State: values['channel1'] == 1,
      channel2State: values['channel2'] == 1,
      channel3State: values['channel3'] == 1,
      channel4State: values['channel4'] == 1,
      channel5State: values['channel5'] == 1,
      channel6State: values['channel6'] == 1,
      channel7State: values['channel7'] == 1,
      channel8State: values['channel8'] == 1,
    );
  }
}
