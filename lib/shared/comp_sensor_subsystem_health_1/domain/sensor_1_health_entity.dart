import 'sensor_1_enums.dart';

class Sensor1HealthEntity {
  final SensorFaultStatus uhfRadioUartCommFault;
  final SensorFaultStatus uhfRadioFirmwareFault;
  final SensorFaultStatus uhfRadioLocalRssiFault;
  final SensorFaultStatus uhfRadioTempFault;
  final SensorFaultStatus uhfLinkConHeartbeatFault;
  final SensorFaultStatus uhfLinkConRemoteRssiFault;
  final SensorFaultStatus uhfLinkHealthLocalRssiFault;
  final SensorFaultStatus uhfLinkHealthRemoteRssiFault;
  final SensorFaultStatus uhfLinkHealthLocalNoiseFault;
  final SensorFaultStatus uhfLinkHealthRemoteNoiseFault;
  final SensorFaultStatus uhfLinkHealthSnrFault;
  final SensorFaultStatus uhfLinkHealthPackLossFault;
  final SensorFaultStatus uhfLinkHealthHbTimeoutFault;
  final SensorConnectionStatus uhfLinkConnection;
  final SensorLinkHealth uhfLinkHealth;

  const Sensor1HealthEntity({
    required this.uhfRadioUartCommFault,
    required this.uhfRadioFirmwareFault,
    required this.uhfRadioLocalRssiFault,
    required this.uhfRadioTempFault,
    required this.uhfLinkConHeartbeatFault,
    required this.uhfLinkConRemoteRssiFault,
    required this.uhfLinkHealthLocalRssiFault,
    required this.uhfLinkHealthRemoteRssiFault,
    required this.uhfLinkHealthLocalNoiseFault,
    required this.uhfLinkHealthRemoteNoiseFault,
    required this.uhfLinkHealthSnrFault,
    required this.uhfLinkHealthPackLossFault,
    required this.uhfLinkHealthHbTimeoutFault,
    required this.uhfLinkConnection,
    required this.uhfLinkHealth,
  });

  @override
  String toString() {
    return 'Sensor1HealthEntity(uhfRadioUartCommFault: $uhfRadioUartCommFault, uhfRadioFirmwareFault: $uhfRadioFirmwareFault, uhfRadioLocalRssiFault: $uhfRadioLocalRssiFault, uhfRadioTempFault: $uhfRadioTempFault, uhfLinkConHeartbeatFault: $uhfLinkConHeartbeatFault, uhfLinkConRemoteRssiFault: $uhfLinkConRemoteRssiFault, uhfLinkHealthLocalRssiFault: $uhfLinkHealthLocalRssiFault, uhfLinkHealthRemoteRssiFault: $uhfLinkHealthRemoteRssiFault, uhfLinkHealthLocalNoiseFault: $uhfLinkHealthLocalNoiseFault, uhfLinkHealthRemoteNoiseFault: $uhfLinkHealthRemoteNoiseFault, uhfLinkHealthSnrFault: $uhfLinkHealthSnrFault, uhfLinkHealthPackLossFault: $uhfLinkHealthPackLossFault, uhfLinkHealthHbTimeoutFault: $uhfLinkHealthHbTimeoutFault, uhfLinkConnection: $uhfLinkConnection, uhfLinkHealth: $uhfLinkHealth)';
  }
}
