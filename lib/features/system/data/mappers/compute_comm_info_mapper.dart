import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/compute_comm_info_entity.dart';
import '../../enums/subsystem_status_enum.dart';

class ComputeCommInfoMapper extends CanExtractionStrategy<ComputeCommInfoEntity> {
  static const int id = 0x20C;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'uhfRadio', startBit: 17, endBit: 18),
    const CanField<int>(name: 'lBandRadio', startBit: 19, endBit: 20),
    const CanField<int>(name: 'compute', startBit: 21, endBit: 22),
  ];

  @override
  ComputeCommInfoEntity build(Map<String, dynamic> parsedValues) {
    return ComputeCommInfoEntity(
      uhfRadio: _toStatus(parsedValues['uhfRadio']),
      lBandRadio: _toStatus(parsedValues['lBandRadio']),
      compute: _toStatus(parsedValues['compute']),
    );
  }

  SubsystemStatus _toStatus(int value) {
    switch (value) {
      case 1: return SubsystemStatus.noCommunication;
      case 2: return SubsystemStatus.healthy;
      case 3: return SubsystemStatus.unhealthy;
      default: return SubsystemStatus.unknown;
    }
  }
}
