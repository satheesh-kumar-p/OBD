import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/mc_temp_volt_entity.dart';

class McTempVoltMapper extends CanExtractionStrategy<McTempVoltEntity> {
  static final int _messageId = 0x211;

  @override
  int get messageId => _messageId;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<double>(
      name: 'rearMcVoltage',
      startBit: 37,
      endBit: 46,
      transformer: _scaleVoltage,
    ),
    const CanField<double>(
      name: 'frontMcVoltage',
      startBit: 27,
      endBit: 36,
      transformer: _scaleVoltage,
    ),
    const CanField<int>(
      name: 'rearMcTemp',
      startBit: 16,
      endBit: 23,
    ),
    const CanField<int>(
      name: 'frontMcTemp',
      startBit: 8,
      endBit: 15,
    ),
  ];

  static double _scaleVoltage(int rawValue) => rawValue * 0.1;

  @override
  McTempVoltEntity build(Map<String, dynamic> values) {
    return McTempVoltEntity(
      rearMcVoltage: values['rearMcVoltage'],
      frontMcVoltage: values['frontMcVoltage'],
      rearMcTemp: values['rearMcTemp'],
      frontMcTemp: values['frontMcTemp'],
    );
  }
}
