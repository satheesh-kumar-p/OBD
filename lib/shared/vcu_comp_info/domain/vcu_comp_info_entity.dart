import 'vcu_comp_info_enum.dart';

class VcuCompInfoEntity {
  final VcuCompInfoStatus jetsonHeartbeat;
  final VcuCompInfoStatus tempFault;
  final VcuCompInfoStatus voltFault;
  final VcuCompInfoStatus cpuLoadFault;

  const VcuCompInfoEntity({
    required this.jetsonHeartbeat,
    required this.tempFault,
    required this.voltFault,
    required this.cpuLoadFault,
  });

  @override
  String toString() {
    return 'VcuCompInfoEntity{jetsonHeartbeat: $jetsonHeartbeat, '
        'tempFault: $tempFault, '
        'voltFault: $voltFault, '
        'cpuLoadFault: $cpuLoadFault}';
  }
}
