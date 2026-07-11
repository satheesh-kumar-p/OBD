import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/comp_sensor_subsystem_health_1/domain/sensor_1_enums.dart' as s1;
import '../../../shared/comp_sensor_subsystem_health_1/domain/sensor_1_health_entity.dart';
import '../../../shared/comp_sensor_subsystem_health_2/domain/sensor_2_enums.dart' as s2;
import '../../../shared/comp_sensor_subsystem_health_2/domain/sensor_2_health_entity.dart';
import '../../../shared/vcu_subsystem_power_state/domain/power_state_enum.dart';
import '../../../shared/vcu_subsystem_power_state/domain/vcu_subsystem_power_state_entity.dart';
import '../../core/enums/subsystem_fault_state_enum.dart';
import '../../shared/comp_subsystem_state/domain/entities/comp_subsystem_state_entity.dart';

class CommunicationItem {
  final String label;
  final String? value;
  final Color? color;
  final bool isText;

  const CommunicationItem(this.label, [this.color, this.value, this.isText = false]);
  bool get isHeader => color == null;
}

class CommunicationTileState {
  final String title;
  final List<CommunicationItem> items;

  const CommunicationTileState({
    required this.title,
    required this.items,
  });
}

class CommunicationState {
  final Sensor1HealthEntity? sensor1;
  final Sensor2HealthEntity? sensor2;
  final CompSubsystemStateEntity? radioFault;
  final VcuSubsystemPowerStateEntity? powerState;

  const CommunicationState({
    this.sensor1,
    this.sensor2,
    this.radioFault,
    this.powerState,
  });

  CommunicationTileState get uhfRadioTile {
    final s = sensor1;
    final isOn = powerState?.uhfRadio == PowerStateEnum.on;
    return CommunicationTileState(
      title: 'UHF Radio',
      items: [
        _powerRow('Power Status', powerState?.uhfRadio),
        _row('Overall Health', isOn ? radioFault?.uhfRadio : null),
        const CommunicationItem('Radio Health'),
        _row('UART Comm Fault', isOn ? s?.uhfRadioUartCommFault : null),
        _row('Firmware Fault', isOn ? s?.uhfRadioFirmwareFault : null),
        _row('Local RSSI/Noise Fault', isOn ? s?.uhfRadioLocalRssiFault : null),
        _row('Temperature Fault', isOn ? s?.uhfRadioTempFault : null),
        const CommunicationItem('Link Connection'),
        _row('Health Status', isOn ? s?.uhfLinkConnection : null),
        _row('Heartbeat Fault', isOn ? s?.uhfLinkConHeartbeatFault : null),
        _row('Remote RSSI', isOn ? s?.uhfLinkConRemoteRssiFault : null),
        const CommunicationItem('Link Health'),
        _row('Health Status', isOn ? s?.uhfLinkHealth : null),
        _row('Local RSSI Fault', isOn ? s?.uhfLinkHealthLocalRssiFault : null),
        _row('Remote RSSI Fault', isOn ? s?.uhfLinkHealthRemoteRssiFault : null),
        _row('Local Noise Fault', isOn ? s?.uhfLinkHealthLocalNoiseFault : null),
        _row('Remote Noise Fault', isOn ? s?.uhfLinkHealthRemoteNoiseFault : null),
        _row('SNR Fault', isOn ? s?.uhfLinkHealthSnrFault : null),
        _row('Packet Loss', isOn ? s?.uhfLinkHealthPackLossFault : null),
        _row('HB Timeout Fault', isOn ? s?.uhfLinkHealthHbTimeoutFault : null),
      ],
    );
  }

  CommunicationTileState get lbandRadioTile {
    final s = sensor2;
    final isOn = powerState?.lbandRadio == PowerStateEnum.on;
    return CommunicationTileState(
      title: 'L-Band Radio',
      items: [
        _powerRow('Power Status', powerState?.lbandRadio),
        _row('Overall Health', isOn ? radioFault?.lBandRadio : null),
        const CommunicationItem('Radio Health'),
        _row('Eth Comm Fault', isOn ? s?.lbandEthCommFault : null),
        _row('Firmware Fault', isOn ? s?.lbandFirmwareFault : null),
        _row('Local RSSI/Noise Fault', isOn ? s?.lbandLocalRssiFault : null),
        _row('Temperature Fault', isOn ? s?.lbandTempFault : null),
        const CommunicationItem('Link Connection'),
        _row('Health Status', isOn ? s?.lbandLinkConnection : null),
        _row('Heartbeat Fault', isOn ? s?.lbandLinkConHbFault : null),
        _row('Remote RSSI Fault', isOn ? s?.lbandLinkConRemoteRssiFault : null),
        const CommunicationItem('Link Health'),
        _row('Health Status', isOn ? s?.lbandLinkHealth : null),
        _row('Local RSSI Fault', isOn ? s?.lbandLinkHealthLocalRssiFault : null),
        _row('Remote RSSI Fault', isOn ? s?.lbandLinkHealthRemoteRssiFault : null),
        _row('Local Noise Fault', isOn ? s?.lbandLinkHealthLocalNoiseFault : null),
        _row('Remote Noise Fault', isOn ? s?.lbandLinkHealthRemoteNoiseFault : null),
        _row('SNR Fault', isOn ? s?.lbandLinkHealthSnrFault : null),
        _row('Pack Loss Fault', isOn ? s?.lbandLinkHealthPackLossFault : null),
        _row('HB Timeout Fault', isOn ? s?.lbandLinkHealthHbTimeoutFault : null),
      ],
    );
  }

  CommunicationItem _powerRow(String label, PowerStateEnum? state) {
    Color dotColor = AppColors.unknown;

    if (state == PowerStateEnum.on) {
      dotColor = AppColors.healthy;
    } else if (state == PowerStateEnum.off) {
      dotColor = AppColors.faulty;
    }

    return CommunicationItem(
      label,
      dotColor,
    );
  }

  CommunicationItem _row(String label, Object? state) {
    if (state == null) return CommunicationItem(label, AppColors.unknown);

    final color = switch (state) {
      SubsystemFaultState.healthy ||
      s1.SensorFaultStatus.healthy ||
      s2.SensorFaultStatus.healthy ||
      s1.SensorLinkHealth.healthy ||
      s2.SensorLinkHealth.healthy ||
      s1.SensorConnectionStatus.connected ||
      s2.SensorConnectionStatus.connected =>
        AppColors.healthy,
      s1.SensorLinkHealth.degraded || s2.SensorLinkHealth.degraded => AppColors.degraded,
      s1.SensorFaultStatus.fault ||
      SubsystemFaultState.faulty ||
      s2.SensorFaultStatus.fault ||
      s1.SensorLinkHealth.faulty ||
      s2.SensorLinkHealth.faulty ||
      s1.SensorConnectionStatus.disconnected ||
      s2.SensorConnectionStatus.disconnected =>
        AppColors.faulty,
      _ => AppColors.unknown,
    };

    return CommunicationItem(label, color);
  }
}
