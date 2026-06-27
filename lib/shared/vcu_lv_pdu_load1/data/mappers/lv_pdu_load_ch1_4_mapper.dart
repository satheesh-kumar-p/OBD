import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/lv_pdu_load_ch1_4_entity.dart';

class LvPduLoadCh1_4Mapper extends CanExtractionStrategy<LvPduLoadCh14Entity> {
  static final int id = 0x223;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<double>(
      name: 'channel1Current',
      startBit: 32,
      endBit: 39,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel2Current',
      startBit: 24,
      endBit: 31,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel3Current',
      startBit: 16,
      endBit: 23,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel4Current',
      startBit: 8,
      endBit: 15,
      transformer: _scaleCurrent,
    ),
  ];

  @override
  LvPduLoadCh14Entity build(Map<String, dynamic> values) {
    return LvPduLoadCh14Entity(
      channel1Current: values['channel1Current'],
      channel2Current: values['channel2Current'],
      channel3Current: values['channel3Current'],
      channel4Current: values['channel4Current'],
    );
  }

  static double _scaleCurrent(int raw) => raw / 10;
}
