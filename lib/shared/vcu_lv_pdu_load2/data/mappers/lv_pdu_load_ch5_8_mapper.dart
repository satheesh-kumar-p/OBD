import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/lv_pdu_load_ch5_8_entity.dart';

class LvPduVcuLoadCh5_8Mapper extends CanExtractionStrategy<LvPduLoadCh5_8Entity> {
  static final int id = 0x224;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<double>(
      name: 'channel5Current',
      startBit: 32,
      endBit: 39,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel6Current',
      startBit: 24,
      endBit: 31,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel7Current',
      startBit: 16,
      endBit: 23,
      transformer: _scaleCurrent,
    ),
    const CanField<double>(
      name: 'channel8Current',
      startBit: 8,
      endBit: 15,
      transformer: _scaleCurrent,
    ),
  ];

  @override
  LvPduLoadCh5_8Entity build(Map<String, dynamic> values) {
    return LvPduLoadCh5_8Entity(
      channel5Current: values['channel5Current'],
      channel6Current: values['channel6Current'],
      channel7Current: values['channel7Current'],
      channel8Current: values['channel8Current'],
    );
  }

  static double _scaleCurrent(int raw) => raw / 10;
}
