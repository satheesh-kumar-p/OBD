import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/comp_sensor_subsystem_health_1/domain/sensor_1_enums.dart' as s1;
import '../../../shared/comp_sensor_subsystem_health_1/domain/sensor_1_health_entity.dart';
import '../../../shared/comp_sensor_subsystem_health_2/domain/sensor_2_enums.dart' as s2;
import '../../../shared/comp_sensor_subsystem_health_2/domain/sensor_2_health_entity.dart';
import '../../../shared/vcu_subsystem_power_state/domain/power_state_enum.dart';
import '../../../shared/vcu_subsystem_power_state/domain/vcu_subsystem_power_state_entity.dart';

class SensorItemState {
  final String label;
  final String? value;
  final Color color;
  final bool isText;

  const SensorItemState({
    required this.label,
    this.value,
    required this.color,
    this.isText = false,
  });
}

class SensorTileState {
  final String title;
  final List<SensorItemState> items;

  const SensorTileState({
    required this.title,
    required this.items,
  });
}

class SensorState {
  final Sensor1HealthEntity? sensor1;
  final Sensor2HealthEntity? sensor2;
  final VcuSubsystemPowerStateEntity? powerState;

  const SensorState({
    this.sensor1,
    this.sensor2,
    this.powerState,
  });

  bool get isLoading => sensor1 == null && sensor2 == null && powerState == null;

  List<SensorTileState> get tiles => [
        _ethernetSwitchTile,
        _gnssTile,
        _imuTile,
        _lidar2dTile,
        _lidar3dTile,
        _camerasTile,
      ];

  List<SensorTileState> get leftCol => [
    _camerasTile,
    _imuTile,
  ];

  List<SensorTileState> get rightCol => [
    _ethernetSwitchTile,
    _lidar2dTile,
  ];

  List<SensorTileState> get middleCol => [
    _gnssTile,
    _lidar3dTile,
  ];

  SensorTileState get _ethernetSwitchTile {
    final s = sensor2;
    final isOn = powerState?.ethernetSwitch == PowerStateEnum.on;
    return SensorTileState(
      title: 'Ethernet Switch',
      items: [
        _powerRow('Power Status', powerState?.ethernetSwitch),
        _row('GNSS Ping Fault', isOn ? s?.ethGnssPingFault : null),
        _row('L-Band Radio Ping Fault', isOn ? s?.ethLbandRadioPingFault : null),
        _row('2D Lidar Ping Fault', isOn ? s?.eth2dLidarPingFault : null),
        _row('3D Lidar Ping Fault', isOn ? s?.eth3dLidarPingFault : null),
        _row('Sec Compute Ping Fault', isOn ? s?.ethSecCompPingFault : null),
      ],
    );
  }

  SensorTileState get _gnssTile {
    final s = sensor2;
    final isOn = powerState?.gnss == PowerStateEnum.on;
    return SensorTileState(
      title: 'GNSS',
      items: [
        _powerRow('Power Status', powerState?.gnss),
        _row('Pos Validity Fault', isOn ? s?.gnssPosValidityErrorFault : null),
        _row('Fix Quality Fault', isOn ? s?.gnssFixQualityFault : null),
        _row('Fix Dimension Fault', isOn ? s?.gnssFixDimFault : null),
        _row('Satellite Fault', isOn ? s?.gnssSatelliteFault : null),
        _row('HDOP Fault', isOn ? s?.gnssHdopFault : null),
        _row('Heading Validity Fault', isOn ? s?.gnssHeadValidFault : null),
      ],
    );
  }

  SensorTileState get _imuTile {
    final s = sensor2;
    final isOn = powerState?.imu == PowerStateEnum.on;
    return SensorTileState(
      title: 'IMU',
      items: [
        _powerRow('Power Status', powerState?.imu),
        _row('Comm Fault', isOn ? s?.imuCommFault : null),
        _row('Data Integrity Fault', isOn ? s?.imuDataIntFault : null),
      ],
    );
  }

  SensorTileState get _lidar2dTile {
    final s = sensor2;
    final isOn = powerState?.lidar2d == PowerStateEnum.on;
    return SensorTileState(
      title: '2D Lidar',
      items: [
        _powerRow('Power Status', powerState?.lidar2d),
        _row('Comm Fault', isOn ? s?.lidar2dCommFault : null),
        _row('Data Integrity Fault', isOn ? s?.lidar2dDataIntFault : null),
      ],
    );
  }

  SensorTileState get _lidar3dTile {
    final s = sensor2;
    final isOn = powerState?.lidar3d == PowerStateEnum.on;
    return SensorTileState(
      title: '3D Lidar',
      items: [
        _powerRow('Power Status', powerState?.lidar3d),
        _row('Comm Fault', isOn ? s?.lidar3dCommFault : null),
        _row('Data Integrity Fault', isOn ? s?.lidar3dDataIntFault : null),
      ],
    );
  }

  SensorTileState get _camerasTile {
    final s = sensor2;
    final isOn = powerState?.rgbdCam == PowerStateEnum.on;
    return SensorTileState(
      title: 'Cameras',
      items: [
        _powerRow('Power Status', powerState?.rgbdCam),
        _row('Front-Centre', isOn ? s?.camForwardCentreFault : null),
        _row('Front-Port', isOn ? s?.camForwardPortFault : null),
        _row('Front-Starboard', isOn ? s?.camForwardStarboardFault : null),
        _row('Side-Port', isOn ? s?.camSidePortFault : null),
        _row('Side-Starboard', isOn ? s?.camSideStarboardFault : null),
        _row('Aft', isOn ? s?.camAftFault : null),
      ],
    );
  }

  SensorItemState _powerRow(String label, PowerStateEnum? state) {
    String valueText = 'UNKNOWN';
    Color textColor = AppColors.unknown;

    if (state == PowerStateEnum.on) {
      valueText = 'ON';
      textColor = AppColors.healthy;
    } else if (state == PowerStateEnum.off) {
      valueText = 'OFF';
      textColor = AppColors.faulty;
    }

    return SensorItemState(
      label: label,
      value: valueText,
      color: textColor,
      isText: false,
    );
  }

  SensorItemState _row(String label, Object? state) {
    if (state == null) return SensorItemState(label: label, color: AppColors.unknown);

    final color = switch (state) {
      s1.SensorFaultStatus.healthy ||
      s2.SensorFaultStatus.healthy ||
      s1.SensorLinkHealth.healthy ||
      s2.SensorLinkHealth.healthy ||
      s1.SensorConnectionStatus.connected ||
      s2.SensorConnectionStatus.connected ||
      s2.CameraStatus.healthy =>
        AppColors.healthy,
      s1.SensorLinkHealth.degraded || s2.SensorLinkHealth.degraded => AppColors.degraded,
      s1.SensorFaultStatus.fault ||
      s2.SensorFaultStatus.fault ||
      s1.SensorLinkHealth.faulty ||
      s2.SensorLinkHealth.faulty ||
      s1.SensorConnectionStatus.disconnected ||
      s2.SensorConnectionStatus.disconnected ||
      s2.CameraStatus.faulty =>
        AppColors.faulty,
      _ => AppColors.unknown,
    };

    return SensorItemState(label: label, color: color);
  }
}
