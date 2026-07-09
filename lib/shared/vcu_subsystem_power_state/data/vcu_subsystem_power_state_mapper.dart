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
      forwardMc: PowerStateEnum.fromInt(values['forwardMc']),
      aftMc: PowerStateEnum.fromInt(values['aftMc']),
      dcDc: PowerStateEnum.fromInt(values['dcDc']),
      hvPdu: PowerStateEnum.fromInt(values['hvPdu']),
      lvPdu: PowerStateEnum.fromInt(values['lvPdu']),
      uhfRadio: PowerStateEnum.fromInt(values['uhfRadio']),
      lbandRadio: PowerStateEnum.fromInt(values['lbandRadio']),
      ethernetSwitch: PowerStateEnum.fromInt(values['ethernetSwitch']),
      gnss: PowerStateEnum.fromInt(values['gnss']),
      imu: PowerStateEnum.fromInt(values['imu']),
      lidar2d: PowerStateEnum.fromInt(values['lidar2d']),
      lidar3d: PowerStateEnum.fromInt(values['lidar3d']),
      vcu: PowerStateEnum.fromInt(values['vcu']),
      mainComp: PowerStateEnum.fromInt(values['mainComp']),
      secComp: PowerStateEnum.fromInt(values['secComp']),
      rgbdCam: PowerStateEnum.fromInt(values['rgbdCam']),
      headLights: PowerStateEnum.fromInt(values['headLights']),
      aftLights: PowerStateEnum.fromInt(values['aftLights']),
      fogLights: PowerStateEnum.fromInt(values['fogLights']),
      lvBatteryCharger: PowerStateEnum.fromInt(values['lvBatteryCharger']),
    );
  }
}
