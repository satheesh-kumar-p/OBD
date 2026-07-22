import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../domain/sensor_2_health_entity.dart';
import '../domain/sensor_2_enums.dart';

class Sensor2HealthMapper extends CanExtractionStrategy<Sensor2HealthEntity> {
  static final int id = 0x22D;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(name: 'lband_eth_comm_fault', startBit: 46, endBit: 46),
    const CanField<int>(name: 'lband_firmware_fault', startBit: 45, endBit: 45),
    const CanField<int>(name: 'lband_local_rssi_fault', startBit: 44, endBit: 44),
    const CanField<int>(name: 'lband_temp_fault', startBit: 43, endBit: 43),
    const CanField<int>(name: 'lband_link_hb_fault', startBit: 42, endBit: 42),
    const CanField<int>(name: 'lband_link_remote_rssi_fault_1', startBit: 41, endBit: 41),
    const CanField<int>(name: 'lband_link_local_rssi_fault', startBit: 40, endBit: 40),
    const CanField<int>(name: 'lband_link_remote_rssi_fault_2', startBit: 39, endBit: 39),
    const CanField<int>(name: 'lband_link_local_noise_fault', startBit: 38, endBit: 38),
    const CanField<int>(name: 'lband_link_remote_noise_fault', startBit: 37, endBit: 37),
    const CanField<int>(name: 'lband_link_snr_fault', startBit: 36, endBit: 36),
    const CanField<int>(name: 'lband_link_pack_loss_fault', startBit: 35, endBit: 35),
    const CanField<int>(name: 'lband_link_hb_timeout_fault', startBit: 34, endBit: 34),
    const CanField<int>(name: 'lband_link_connection', startBit: 32, endBit: 33),
    const CanField<int>(name: 'lband_link_health', startBit: 30, endBit: 31),
    const CanField<int>(name: 'eth_gnss_ping_fault', startBit: 29, endBit: 29),
    const CanField<int>(name: 'eth_lband_radio_ping_fault', startBit: 28, endBit: 28),
    const CanField<int>(name: 'eth_2d_lidar_ping_fault', startBit: 27, endBit: 27),
    const CanField<int>(name: 'eth_3d_lidar_ping_fault', startBit: 26, endBit: 26),
    const CanField<int>(name: 'eth_sec_comp_ping_fault', startBit: 25, endBit: 25),
    const CanField<int>(name: 'gnss_pos_validity_error_fault', startBit: 24, endBit: 24),
    const CanField<int>(name: 'gnss_fix_quality_fault', startBit: 23, endBit: 23),
    const CanField<int>(name: 'gnss_fix_dim_fault', startBit: 22, endBit: 22),
    const CanField<int>(name: 'gnss_satellite_fault', startBit: 21, endBit: 21),
    const CanField<int>(name: 'gnss_hdop_fault', startBit: 20, endBit: 20),
    const CanField<int>(name: 'gnss_head_valid_fault', startBit: 19, endBit: 19),
    const CanField<int>(name: 'imu_comm_fault', startBit: 18, endBit: 18),
    const CanField<int>(name: 'imu_data_int_fault', startBit: 17, endBit: 17),
    const CanField<int>(name: 'lidar_2d_comm_fault', startBit: 16, endBit: 16),
    const CanField<int>(name: 'lidar_2d_data_int_fault', startBit: 15, endBit: 15),
    const CanField<int>(name: 'lidar_3d_comm_fault', startBit: 14, endBit: 14),
    const CanField<int>(name: 'cam_forward_centre_fault', startBit: 12, endBit: 13),
    const CanField<int>(name: 'cam_forward_port_fault', startBit: 10, endBit: 11),
    const CanField<int>(name: 'cam_forward_starboard_fault', startBit: 8, endBit: 9),
    const CanField<int>(name: 'cam_side_port_fault', startBit: 6, endBit: 7),
    const CanField<int>(name: 'cam_side_starboard_fault', startBit: 4, endBit: 5),
    const CanField<int>(name: 'cam_aft_fault', startBit: 2, endBit: 3),
    const CanField<int>(name: 'lidar_3d_data_int_fault', startBit: 1, endBit: 1),
  ];

  @override
  Sensor2HealthEntity build(Map<String, dynamic> values) {
    return Sensor2HealthEntity(
      lbandEthCommFault: SensorFaultStatus.fromInt(values['lband_eth_comm_fault']),
      lbandFirmwareFault: SensorFaultStatus.fromInt(values['lband_firmware_fault']),
      lbandLocalRssiFault: SensorFaultStatus.fromInt(values['lband_local_rssi_fault']),
      lbandTempFault: SensorFaultStatus.fromInt(values['lband_temp_fault']),
      lbandLinkConHbFault: SensorFaultStatus.fromInt(values['lband_link_hb_fault']),
      lbandLinkConRemoteRssiFault: SensorFaultStatus.fromInt(values['lband_link_remote_rssi_fault_1']),
      lbandLinkHealthLocalRssiFault: SensorFaultStatus.fromInt(values['lband_link_local_rssi_fault']),
      lbandLinkHealthRemoteRssiFault: SensorFaultStatus.fromInt(values['lband_link_remote_rssi_fault_2']),
      lbandLinkHealthLocalNoiseFault: SensorFaultStatus.fromInt(values['lband_link_local_noise_fault']),
      lbandLinkHealthRemoteNoiseFault: SensorFaultStatus.fromInt(values['lband_link_remote_noise_fault']),
      lbandLinkHealthSnrFault: SensorFaultStatus.fromInt(values['lband_link_snr_fault']),
      lbandLinkHealthPackLossFault: SensorFaultStatus.fromInt(values['lband_link_pack_loss_fault']),
      lbandLinkHealthHbTimeoutFault: SensorFaultStatus.fromInt(values['lband_link_hb_timeout_fault']),
      lbandLinkConnection: SensorConnectionStatus.fromInt(values['lband_link_connection']),
      lbandLinkHealth: SensorLinkHealth.fromInt(values['lband_link_health']),
      ethGnssPingFault: SensorFaultStatus.fromInt(values['eth_gnss_ping_fault']),
      ethLbandRadioPingFault: SensorFaultStatus.fromInt(values['eth_lband_radio_ping_fault']),
      eth2dLidarPingFault: SensorFaultStatus.fromInt(values['eth_2d_lidar_ping_fault']),
      eth3dLidarPingFault: SensorFaultStatus.fromInt(values['eth_3d_lidar_ping_fault']),
      ethSecCompPingFault: SensorFaultStatus.fromInt(values['eth_sec_comp_ping_fault']),
      gnssPosValidityErrorFault: SensorFaultStatus.fromInt(values['gnss_pos_validity_error_fault']),
      gnssFixQualityFault: SensorFaultStatus.fromInt(values['gnss_fix_quality_fault']),
      gnssFixDimFault: SensorFaultStatus.fromInt(values['gnss_fix_dim_fault']),
      gnssSatelliteFault: SensorFaultStatus.fromInt(values['gnss_satellite_fault']),
      gnssHdopFault: SensorFaultStatus.fromInt(values['gnss_hdop_fault']),
      gnssHeadValidFault: SensorFaultStatus.fromInt(values['gnss_head_valid_fault']),
      imuCommFault: SensorFaultStatus.fromInt(values['imu_comm_fault']),
      imuDataIntFault: SensorFaultStatus.fromInt(values['imu_data_int_fault']),
      lidar2dCommFault: SensorFaultStatus.fromInt(values['lidar_2d_comm_fault']),
      lidar2dDataIntFault: SensorFaultStatus.fromInt(values['lidar_2d_data_int_fault']),
      lidar3dCommFault: SensorFaultStatus.fromInt(values['lidar_3d_comm_fault']),
      lidar3dDataIntFault: SensorFaultStatus.fromInt(values['lidar_3d_data_int_fault']),
      camForwardCentreFault: CameraStatus.fromInt(values['cam_forward_centre_fault']),
      camForwardPortFault: CameraStatus.fromInt(values['cam_forward_port_fault']),
      camForwardStarboardFault: CameraStatus.fromInt(values['cam_forward_starboard_fault']),
      camSidePortFault: CameraStatus.fromInt(values['cam_side_port_fault']),
      camSideStarboardFault: CameraStatus.fromInt(values['cam_side_starboard_fault']),
      camAftFault: CameraStatus.fromInt(values['cam_aft_fault']),
    );
  }
}
