import 'package:scout_obd/shared/vcu_estop_status/domain/entities/e_stop_info_entity.dart';
import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../enums/e_stop_status_enum.dart';

class EStopInfoMapper extends CanExtractionStrategy<EStopInfoEntity> {
  static final int id = 0x201;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'eStopStatus',
      startBit: 46,
      endBit: 46,
    ),
  ];

  @override
  EStopInfoEntity build(Map<String, dynamic> parsedValues) {
    final statusValue = parsedValues['eStopStatus'] as int;
    
    return EStopInfoEntity(
      status: EStopStatus.values.firstWhere(
        (e) => e.value == statusValue,
        orElse: () => EStopStatus.unknown,
      ),
    );
  }
}
