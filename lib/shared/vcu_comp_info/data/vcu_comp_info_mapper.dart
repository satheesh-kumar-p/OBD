import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../domain/vcu_comp_info_entity.dart';
import '../domain/vcu_comp_info_enum.dart';

class VcuCompInfoMapper extends CanExtractionStrategy<VcuCompInfoEntity> {
  static const int id = 0x221;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
        const CanField<int>(name: 'jetsonHeartbeat', startBit: 39, endBit: 39),
        const CanField<int>(name: 'tempFault', startBit: 38, endBit: 38),
        const CanField<int>(name: 'voltFault', startBit: 37, endBit: 37),
        const CanField<int>(name: 'cpuLoadFault', startBit: 36, endBit: 36),
      ];

  @override
  VcuCompInfoEntity build(Map<String, dynamic> values) {
    return VcuCompInfoEntity(
      jetsonHeartbeat: VcuCompInfoStatus.fromInt(values['jetsonHeartbeat']),
      tempFault: VcuCompInfoStatus.fromInt(values['tempFault']),
      voltFault: VcuCompInfoStatus.fromInt(values['voltFault']),
      cpuLoadFault: VcuCompInfoStatus.fromInt(values['cpuLoadFault']),
    );
  }
}
