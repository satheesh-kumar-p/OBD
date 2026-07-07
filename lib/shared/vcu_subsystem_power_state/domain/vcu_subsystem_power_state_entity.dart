import 'power_state_enum.dart';

class VcuSubsystemPowerStateEntity {
  final PowerState forwardMc;
  final PowerState aftMc;
  final PowerState dcDc;
  final PowerState hvPdu;
  final PowerState lvPdu;
  final PowerState uhfRadio;
  final PowerState lbandRadio;
  final PowerState ethernetSwitch;
  final PowerState gnss;
  final PowerState imu;
  final PowerState lidar2d;
  final PowerState lidar3d;
  final PowerState vcu;
  final PowerState mainComp;
  final PowerState secComp;
  final PowerState rgbdCam;
  final PowerState headLights;
  final PowerState aftLights;
  final PowerState fogLights;
  final PowerState lvBatteryCharger;

  const VcuSubsystemPowerStateEntity({
    required this.forwardMc,
    required this.aftMc,
    required this.dcDc,
    required this.hvPdu,
    required this.lvPdu,
    required this.uhfRadio,
    required this.lbandRadio,
    required this.ethernetSwitch,
    required this.gnss,
    required this.imu,
    required this.lidar2d,
    required this.lidar3d,
    required this.vcu,
    required this.mainComp,
    required this.secComp,
    required this.rgbdCam,
    required this.headLights,
    required this.aftLights,
    required this.fogLights,
    required this.lvBatteryCharger,
  });

  @override
  String toString() {
    return 'VcuSubsystemPowerState(\n'
        '  forwardMc: $forwardMc,\n'
        '  aftMc: $aftMc,\n'
        '  dcDc: $dcDc,\n'
        '  hvPdu: $hvPdu,\n'
        '  lvPdu: $lvPdu,\n'
        '  uhfRadio: $uhfRadio,\n'
        '  lbandRadio: $lbandRadio,\n'
        '  ethernetSwitch: $ethernetSwitch,\n'
        '  gnss: $gnss,\n'
        '  imu: $imu,\n'
        '  lidar2d: $lidar2d,\n'
        '  lidar3d: $lidar3d,\n'
        '  vcu: $vcu,\n'
        '  mainComp: $mainComp,\n'
        '  secComp: $secComp,\n'
        '  rgbdCam: $rgbdCam,\n'
        '  headLights: $headLights,\n'
        '  aftLights: $aftLights,\n'
        '  fogLights: $fogLights,\n'
        '  lvBatteryCharger: $lvBatteryCharger\n'
        ')';
  }
}
