import 'package:scout_obd/features/dashboard/domain/entities/e_stop_info_entity.dart';
import '../../enums/e_stop_status_enum.dart';
import '../../../../shared/data/can_field.dart';

class EStopInfoMapper extends CanExtractionStrategy<EStopInfoEntity> {
  static final int id = 0x201;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'eStopStatus',
      startBit: 17,
      endBit: 17,
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
