import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../domain/power_state_enum.dart';
import '../domain/vcu_subsystem_power_state_entity.dart';

class VcuSubsystemPowerStateMapper extends CanExtractionStrategy<VcuSubsystemPowerStateEntity> {
  static const int id = 0x222;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'forwardMc', startBit: 45, endBit: 46),
    const CanField<int>(name: 'aftMc', startBit: 43, endBit: 44),
    const CanField<int>(name: 'dcDc', startBit: 41, endBit: 42),
    const CanField<int>(name: 'hvPdu', startBit: 38, endBit: 39),
    const CanField<int>(name: 'lvPdu', startBit: 36, endBit: 37),
    const CanField<int>(name: 'uhfRadio', startBit: 34, endBit: 35),
    const CanField<int>(name: 'lbandRadio', startBit: 32, endBit: 33),
    const CanField<int>(name: 'ethernetSwitch', startBit: 30, endBit: 31),
    const CanField<int>(name: 'gnss', startBit: 28, endBit: 29),
    const CanField<int>(name: 'imu', startBit: 26, endBit: 27),
    const CanField<int>(name: 'lidar2d', startBit: 24, endBit: 25),
    const CanField<int>(name: 'lidar3d', startBit: 22, endBit: 23),
    const CanField<int>(name: 'vcu', startBit: 20, endBit: 21),
    const CanField<int>(name: 'mainComp', startBit: 18, endBit: 19),
    const CanField<int>(name: 'secComp', startBit: 16, endBit: 17),
    const CanField<int>(name: 'rgbdCam', startBit: 14, endBit: 15),
    const CanField<int>(name: 'headLights', startBit: 12, endBit: 13),
    const CanField<int>(name: 'aftLights', startBit: 10, endBit: 11),
    const CanField<int>(name: 'fogLights', startBit: 8, endBit: 9),
    const CanField<int>(name: 'lvBatteryCharger', startBit: 6, endBit: 7),
  ];

  @override
  VcuSubsystemPowerStateEntity build(Map<String, dynamic> values) {
    return VcuSubsystemPowerStateEntity(
      forwardMc: PowerState.fromInt(values['forwardMc']),
      aftMc: PowerState.fromInt(values['aftMc']),
      dcDc: PowerState.fromInt(values['dcDc']),
      hvPdu: PowerState.fromInt(values['hvPdu']),
      lvPdu: PowerState.fromInt(values['lvPdu']),
      uhfRadio: PowerState.fromInt(values['uhfRadio']),
      lbandRadio: PowerState.fromInt(values['lbandRadio']),
      ethernetSwitch: PowerState.fromInt(values['ethernetSwitch']),
      gnss: PowerState.fromInt(values['gnss']),
      imu: PowerState.fromInt(values['imu']),
      lidar2d: PowerState.fromInt(values['lidar2d']),
      lidar3d: PowerState.fromInt(values['lidar3d']),
      vcu: PowerState.fromInt(values['vcu']),
      mainComp: PowerState.fromInt(values['mainComp']),
      secComp: PowerState.fromInt(values['secComp']),
      rgbdCam: PowerState.fromInt(values['rgbdCam']),
      headLights: PowerState.fromInt(values['headLights']),
      aftLights: PowerState.fromInt(values['aftLights']),
      fogLights: PowerState.fromInt(values['fogLights']),
      lvBatteryCharger: PowerState.fromInt(values['lvBatteryCharger']),
    );
  }
}
