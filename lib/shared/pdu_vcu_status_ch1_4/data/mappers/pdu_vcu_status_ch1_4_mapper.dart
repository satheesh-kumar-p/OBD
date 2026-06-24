import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/pdu_vcu_status_ch1_4_entity.dart';

class PduVcuStatusCh1_4Mapper extends CanExtractionStrategy<PduVcuStatusCh1_4Entity> {
  static final int id = 0x000A0610;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<double>(
      name: 'channel1Current',
      startBit: 48,
      endBit: 57,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel2Current',
      startBit: 32,
      endBit: 41,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel3Current',
      startBit: 16,
      endBit: 25,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel4Current',
      startBit: 0,
      endBit: 9,
      transformer: _scaleCurrent,
    ),
  ];

  @override
  PduVcuStatusCh1_4Entity build(Map<String, dynamic> values) {
    return PduVcuStatusCh1_4Entity(
      channel1Current: values['channel1Current'],
      channel2Current: values['channel2Current'],
      channel3Current: values['channel3Current'],
      channel4Current: values['channel4Current'],
    );
  }

  static double _scaleCurrent(int raw) => raw * 0.1;
}
