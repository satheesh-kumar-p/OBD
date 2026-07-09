import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../domain/sensor_1_health_entity.dart';
import '../domain/sensor_1_enums.dart';

class Sensor1HealthMapper extends CanExtractionStrategy<Sensor1HealthEntity> {
  static final int id = 0x22B;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'uhf_radio_uart_comm_fault', startBit: 46, endBit: 46),
    const CanField<int>(name: 'uhf_radio_firmware_fault', startBit: 45, endBit: 45),
    const CanField<int>(name: 'uhf_radio_local_rssi_fault', startBit: 44, endBit: 44),
    const CanField<int>(name: 'uhf_radio_temp_fault', startBit: 43, endBit: 43),
    const CanField<int>(name: 'uhf_link_con_heartbeat_fault', startBit: 42, endBit: 42),
    const CanField<int>(name: 'uhf_link_con_remote_rssi_fault', startBit: 41, endBit: 41),
    const CanField<int>(name: 'uhf_link_health_local_rssi_fault', startBit: 40, endBit: 40),
    const CanField<int>(name: 'uhf_link_health_remote_rssi_fault', startBit: 39, endBit: 39),
    const CanField<int>(name: 'uhf_link_health_local_noise_fault', startBit: 38, endBit: 38),
    const CanField<int>(name: 'uhf_link_health_remote_noise_fault', startBit: 37, endBit: 37),
    const CanField<int>(name: 'uhf_link_health_snr_fault', startBit: 36, endBit: 36),
    const CanField<int>(name: 'uhf_link_health_pack_loss_fault', startBit: 35, endBit: 35),
    const CanField<int>(name: 'uhf_link_health_hb_timeout_fault', startBit: 34, endBit: 34),
    const CanField<int>(name: 'uhf_link_connection', startBit: 32, endBit: 33),
    const CanField<int>(name: 'uhf_link_health', startBit: 30, endBit: 31),
  ];

  @override
  Sensor1HealthEntity build(Map<String, dynamic> values) {
    return Sensor1HealthEntity(
      uhfRadioUartCommFault: SensorFaultStatus.fromInt(values['uhf_radio_uart_comm_fault']),
      uhfRadioFirmwareFault: SensorFaultStatus.fromInt(values['uhf_radio_firmware_fault']),
      uhfRadioLocalRssiFault: SensorFaultStatus.fromInt(values['uhf_radio_local_rssi_fault']),
      uhfRadioTempFault: SensorFaultStatus.fromInt(values['uhf_radio_temp_fault']),
      uhfLinkConHeartbeatFault: SensorFaultStatus.fromInt(values['uhf_link_con_heartbeat_fault']),
      uhfLinkConRemoteRssiFault: SensorFaultStatus.fromInt(values['uhf_link_con_remote_rssi_fault']),
      uhfLinkHealthLocalRssiFault: SensorFaultStatus.fromInt(values['uhf_link_health_local_rssi_fault']),
      uhfLinkHealthRemoteRssiFault: SensorFaultStatus.fromInt(values['uhf_link_health_remote_rssi_fault']),
      uhfLinkHealthLocalNoiseFault: SensorFaultStatus.fromInt(values['uhf_link_health_local_noise_fault']),
      uhfLinkHealthRemoteNoiseFault: SensorFaultStatus.fromInt(values['uhf_link_health_remote_noise_fault']),
      uhfLinkHealthSnrFault: SensorFaultStatus.fromInt(values['uhf_link_health_snr_fault']),
      uhfLinkHealthPackLossFault: SensorFaultStatus.fromInt(values['uhf_link_health_pack_loss_fault']),
      uhfLinkHealthHbTimeoutFault: SensorFaultStatus.fromInt(values['uhf_link_health_hb_timeout_fault']),
      uhfLinkConnection: SensorConnectionStatus.fromInt(values['uhf_link_connection']),
      uhfLinkHealth: SensorLinkHealth.fromInt(values['uhf_link_health']),
    );
  }
}
