import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/pdu_vcu_status_ch5_8_entity.dart';

class PduVcuStatusCh5_8Mapper extends CanExtractionStrategy<PduVcuStatusCh5_8Entity> {
  static final int id = 0x000A0611;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<double>(
      name: 'channel5Current',
      startBit: 48,
      endBit: 57,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel6Current',
      startBit: 32,
      endBit: 41,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel7Current',
      startBit: 16,
      endBit: 25,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel8Current',
      startBit: 0,
      endBit: 9,
      transformer: _scaleCurrent,
    ),
  ];

  @override
  PduVcuStatusCh5_8Entity build(Map<String, dynamic> values) {
    return PduVcuStatusCh5_8Entity(
      channel5Current: values['channel5Current'],
      channel6Current: values['channel6Current'],
      channel7Current: values['channel7Current'],
      channel8Current: values['channel8Current'],
    );
  }

  static double _scaleCurrent(int raw) => raw * 0.1;
}
