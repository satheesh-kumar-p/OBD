import 'sensor_2_enums.dart';

class Sensor2HealthEntity {
  final SensorFaultStatus lbandEthCommFault;
  final SensorFaultStatus lbandFirmwareFault;
  final SensorFaultStatus lbandLocalRssiFault;
  final SensorFaultStatus lbandTempFault;
  final SensorFaultStatus lbandLinkConHbFault;
  final SensorFaultStatus lbandLinkConRemoteRssiFault;
  final SensorFaultStatus lbandLinkHealthLocalRssiFault;
  final SensorFaultStatus lbandLinkHealthRemoteRssiFault;
  final SensorFaultStatus lbandLinkHealthLocalNoiseFault;
  final SensorFaultStatus lbandLinkHealthRemoteNoiseFault;
  final SensorFaultStatus lbandLinkHealthSnrFault;
  final SensorFaultStatus lbandLinkHealthPackLossFault;
  final SensorFaultStatus lbandLinkHealthHbTimeoutFault;
  final SensorConnectionStatus lbandLinkConnection;
  final SensorLinkHealth lbandLinkHealth;
  final SensorFaultStatus ethGnssPingFault;
  final SensorFaultStatus ethLbandRadioPingFault;
  final SensorFaultStatus eth2dLidarPingFault;
  final SensorFaultStatus eth3dLidarPingFault;
  final SensorFaultStatus ethSecCompPingFault;
  final SensorFaultStatus gnssPosValidityErrorFault;
  final SensorFaultStatus gnssFixQualityFault;
  final SensorFaultStatus gnssFixDimFault;
  final SensorFaultStatus gnssSatelliteFault;
  final SensorFaultStatus gnssHdopFault;
  final SensorFaultStatus gnssHeadValidFault;
  final SensorFaultStatus imuCommFault;
  final SensorFaultStatus imuDataIntFault;
  final SensorFaultStatus lidar2dCommFault;
  final SensorFaultStatus lidar2dDataIntFault;
  final SensorFaultStatus lidar3dCommFault;
  final SensorFaultStatus lidar3dDataIntFault;
  final CameraStatus camForwardCentreFault;
  final CameraStatus camForwardPortFault;
  final CameraStatus camForwardStarboardFault;
  final CameraStatus camSidePortFault;
  final CameraStatus camSideStarboardFault;
  final CameraStatus camAftFault;

  const Sensor2HealthEntity({
    required this.lbandEthCommFault,
    required this.lbandFirmwareFault,
    required this.lbandLocalRssiFault,
    required this.lbandTempFault,
    required this.lbandLinkConHbFault,
    required this.lbandLinkConRemoteRssiFault,
    required this.lbandLinkHealthLocalRssiFault,
    required this.lbandLinkHealthRemoteRssiFault,
    required this.lbandLinkHealthLocalNoiseFault,
    required this.lbandLinkHealthRemoteNoiseFault,
    required this.lbandLinkHealthSnrFault,
    required this.lbandLinkHealthPackLossFault,
    required this.lbandLinkHealthHbTimeoutFault,
    required this.lbandLinkConnection,
    required this.lbandLinkHealth,
    required this.ethGnssPingFault,
    required this.ethLbandRadioPingFault,
    required this.eth2dLidarPingFault,
    required this.eth3dLidarPingFault,
    required this.ethSecCompPingFault,
    required this.gnssPosValidityErrorFault,
    required this.gnssFixQualityFault,
    required this.gnssFixDimFault,
    required this.gnssSatelliteFault,
    required this.gnssHdopFault,
    required this.gnssHeadValidFault,
    required this.imuCommFault,
    required this.imuDataIntFault,
    required this.lidar2dCommFault,
    required this.lidar2dDataIntFault,
    required this.lidar3dCommFault,
    required this.lidar3dDataIntFault,
    required this.camForwardCentreFault,
    required this.camForwardPortFault,
    required this.camForwardStarboardFault,
    required this.camSidePortFault,
    required this.camSideStarboardFault,
    required this.camAftFault,
  });

  @override
  String toString() {
    return 'Sensor2HealthEntity(lbandEthCommFault: $lbandEthCommFault, lbandFirmwareFault: $lbandFirmwareFault, lbandLocalRssiFault: $lbandLocalRssiFault, lbandTempFault: $lbandTempFault, lbandLinkConHbFault: $lbandLinkConHbFault, lbandLinkConRemoteRssiFault: $lbandLinkConRemoteRssiFault, lbandLinkHealthLocalRssiFault: $lbandLinkHealthLocalRssiFault, lbandLinkHealthRemoteRssiFault: $lbandLinkHealthRemoteRssiFault, lbandLinkHealthLocalNoiseFault: $lbandLinkHealthLocalNoiseFault, lbandLinkHealthRemoteNoiseFault: $lbandLinkHealthRemoteNoiseFault, lbandLinkHealthSnrFault: $lbandLinkHealthSnrFault, lbandLinkHealthPackLossFault: $lbandLinkHealthPackLossFault, lbandLinkHealthHbTimeoutFault: $lbandLinkHealthHbTimeoutFault, lbandLinkConnection: $lbandLinkConnection, lbandLinkHealth: $lbandLinkHealth, ethGnssPingFault: $ethGnssPingFault, ethLbandRadioPingFault: $ethLbandRadioPingFault, eth2dLidarPingFault: $eth2dLidarPingFault, eth3dLidarPingFault: $eth3dLidarPingFault, ethSecCompPingFault: $ethSecCompPingFault, gnssPosValidityErrorFault: $gnssPosValidityErrorFault, gnssFixQualityFault: $gnssFixQualityFault, gnssFixDimFault: $gnssFixDimFault, gnssSatelliteFault: $gnssSatelliteFault, gnssHdopFault: $gnssHdopFault, gnssHeadValidFault: $gnssHeadValidFault, imuCommFault: $imuCommFault, imuDataIntFault: $imuDataIntFault, lidar2dCommFault: $lidar2dCommFault, lidar2dDataIntFault: $lidar2dDataIntFault, lidar3dCommFault: $lidar3dCommFault, lidar3dDataIntFault: $lidar3dDataIntFault, camForwardCentreFault: $camForwardCentreFault, camForwardPortFault: $camForwardPortFault, camForwardStarboardFault: $camForwardStarboardFault, camSidePortFault: $camSidePortFault, camSideStarboardFault: $camSideStarboardFault, camAftFault: $camAftFault)';
  }
}
