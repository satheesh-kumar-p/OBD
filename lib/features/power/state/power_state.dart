import 'package:flutter/material.dart';
import '../../../shared/vcu_power_subsystem_health/domain/entities/power_health_entity.dart';
import '../../../shared/vcu_contactor_state/domain/entities/vcu_contactor_state_entity.dart';
import '../../../shared/vcu_pdu_status/domain/entities/vcu_pdu_status_entity.dart';
import '../../../shared/vcu_power_subsystem_health/domain/entities/lv_pdu_health_entity.dart';
import '../../../shared/vcu_power_subsystem_health/enums/power_subsystem_status.dart';
import '../../../shared/vcu_power_status/domain/entities/battery_info_entity.dart';
import '../../../shared/pdu_vcu_status_ch1_4/domain/entities/pdu_vcu_status_ch1_4_entity.dart';
import '../../../shared/pdu_vcu_status_ch5_8/domain/entities/pdu_vcu_status_ch5_8_entity.dart';

class PowerState {
  final VcuContactorStateEntity? contactorState;
  final VcuPduStatusEntity? vcuPduStatus;
  final PowerHealthEntity? powerHealth;
  final BatteryInfoEntity? batteryInfo;
  final PduVcuStatusCh1_4Entity? pduCh1_4;
  final PduVcuStatusCh5_8Entity? pduCh5_8;

  const PowerState({
    this.contactorState,
    this.vcuPduStatus,
    this.powerHealth,
    this.batteryInfo,
    this.pduCh1_4,
    this.pduCh5_8,
  });

  bool get isLoading =>
      contactorState == null &&
      vcuPduStatus == null &&
      powerHealth == null &&
      batteryInfo == null &&
      pduCh1_4 == null &&
      pduCh5_8 == null;

  List<ContactorDisplayData> get contactors {
    final state = contactorState;
    return [
      ContactorDisplayData(name: 'DC - DC', stateText: state?.dcDcFeedbackState.name.toUpperCase()),
      ContactorDisplayData(name: 'LV PDU', stateText: state?.lvPduFeedbackState.name.toUpperCase()),
      ContactorDisplayData(name: 'LV BATTERY', stateText: state?.lvBatteryFeedbackState.name.toUpperCase()),
      ContactorDisplayData(name: 'PRECHARGE', stateText: state?.prechargeFeedbackState.name.toUpperCase()),
      ContactorDisplayData(name: 'MOTOR CONTROLLER', stateText: state?.motorControllerFeedbackState.name.toUpperCase()),
    ];
  }

  List<PduChannelDisplayData> get pduChannels {
    final status = vcuPduStatus;
    final ch1_4 = pduCh1_4;
    final ch5_8 = pduCh5_8;
    final healthChannels = powerHealth?.lvPdu.channels;

    return [
      _buildPduChannel(1, status?.channel1State, ch1_4?.channel1Current, healthChannels),
      _buildPduChannel(2, status?.channel2State, ch1_4?.channel2Current, healthChannels),
      _buildPduChannel(3, status?.channel3State, ch1_4?.channel3Current, healthChannels),
      _buildPduChannel(4, status?.channel4State, ch1_4?.channel4Current, healthChannels),
      _buildPduChannel(5, status?.channel5State, ch5_8?.channel5Current, healthChannels),
      _buildPduChannel(6, status?.channel6State, ch5_8?.channel6Current, healthChannels),
      _buildPduChannel(7, status?.channel7State, ch5_8?.channel7Current, healthChannels),
      _buildPduChannel(8, status?.channel8State, ch5_8?.channel8Current, healthChannels),
    ];
  }

  PduChannelDisplayData _buildPduChannel(int chNum, bool? isOn, double? current, List<LvPduChannelHealth>? healthList) {
    LvPduChannelHealth? health;
    if (healthList != null) {
      try {
        health = healthList.firstWhere((h) => h.channelNumber == chNum);
      } catch (_) {}
    }

    return PduChannelDisplayData(
      name: 'CH $chNum',
      isOn: isOn,
      current: current,
      healthColors: [
        _toColor(health?.shortCircuit),
        _toColor(health?.currentLimit),
        _toColor(health?.openCircuit),
      ],
    );
  }

  List<BatteryFaultDisplayData> get batteryFaults {
    final health = powerHealth?.hvBattery;
    return [
      BatteryFaultDisplayData(name: 'Cell Over Voltage', status: health?.singleCellOvervoltage),
      BatteryFaultDisplayData(name: 'Cell Under Voltage', status: health?.singleCellUndervoltage),
      BatteryFaultDisplayData(name: 'Pack Over Voltage', status: health?.packOvervoltage),
      BatteryFaultDisplayData(name: 'Pack Under Voltage', status: health?.packUndervoltage),
      BatteryFaultDisplayData(name: 'Charge Over Temp', status: health?.chargeOverTemperature),
      BatteryFaultDisplayData(name: 'Charge Low Temp', status: health?.chargeLowTemperature),
      BatteryFaultDisplayData(name: 'Discharge Over Temp', status: health?.dischargeOverTemperature),
      BatteryFaultDisplayData(name: 'Discharge Low Temp', status: health?.dischargeLowTemperature),
      BatteryFaultDisplayData(name: 'Charge Over Current', status: health?.chargeOvercurrent),
      BatteryFaultDisplayData(name: 'Discharge Over Current', status: health?.dischargeOvercurrent),
      BatteryFaultDisplayData(name: 'Short Circuit', status: health?.shortCircuitProtection),
      BatteryFaultDisplayData(name: 'Front Detection IC Error', status: health?.frontDetectionIcError),
      BatteryFaultDisplayData(name: 'SW Lock MOS', status: health?.softwareLockMos),
    ];
  }

  List<LargeValueDisplayData> get lvBatteryRows {
    final info = batteryInfo;
    final statusColor = info == null ? Colors.grey : const Color(0xFF74FF9F);
    return [
      LargeValueDisplayData(
        label: 'VOLTAGE',
        value: info == null ? '--' : '${info.lvBatteryVoltage.toStringAsFixed(1)} V',
        color: statusColor,
      ),
      LargeValueDisplayData(
        label: 'SOC',
        value: info == null ? '--' : '${info.lvBatterySoc} %',
        color: statusColor,
      ),
    ];
  }

  PowerState copyWith({
    VcuContactorStateEntity? contactorState,
    VcuPduStatusEntity? vcuPduStatus,
    PowerHealthEntity? powerHealth,
    BatteryInfoEntity? batteryInfo,
    PduVcuStatusCh1_4Entity? pduCh1_4,
    PduVcuStatusCh5_8Entity? pduCh5_8,
  }) {
    return PowerState(
      contactorState: contactorState ?? this.contactorState,
      vcuPduStatus: vcuPduStatus ?? this.vcuPduStatus,
      powerHealth: powerHealth ?? this.powerHealth,
      batteryInfo: batteryInfo ?? this.batteryInfo,
      pduCh1_4: pduCh1_4 ?? this.pduCh1_4,
      pduCh5_8: pduCh5_8 ?? this.pduCh5_8,
    );
  }
}

class ContactorDisplayData {
  final String name;
  final String state;
  final Color color;

  ContactorDisplayData({required this.name, String? stateText})
      : state = stateText ?? '--',
        color = stateText == null
            ? Colors.grey
            : (stateText == 'CLOSED' ? const Color(0xFF74FF9F) : Colors.red);
}

class PduChannelDisplayData {
  final String name;
  final String statusText;
  final String currentText;
  final Color statusColor;
  final List<Color> healthColors;

  PduChannelDisplayData({
    required this.name,
    bool? isOn,
    double? current,
    required this.healthColors,
  })  : statusText = isOn == null ? '--' : (isOn ? 'ON' : 'OFF'),
        currentText = current == null ? '--' : '${current.toStringAsFixed(1)} A',
        statusColor = isOn == null ? Colors.grey : (isOn ? const Color(0xFF74FF9F) : Colors.red);
}

class BatteryFaultDisplayData {
  final String name;
  final Color color;

  BatteryFaultDisplayData({required this.name, PowerSubsystemStatus? status})
      : color = status == null
            ? Colors.grey
            : (status == PowerSubsystemStatus.healthy ? const Color(0xFF74FF9F) : Colors.red);
}

class LargeValueDisplayData {
  final String label;
  final String value;
  final Color color;

  const LargeValueDisplayData({
    required this.label,
    required this.value,
    required this.color,
  });
}

Color _toColor(PowerSubsystemStatus? status) {
  if (status == null) return Colors.grey;
  return status == PowerSubsystemStatus.healthy ? const Color(0xFF74FF9F) : Colors.red;
}
