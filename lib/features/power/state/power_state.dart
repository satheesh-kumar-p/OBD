import 'package:flutter/material.dart';
import '../../../shared/vcu_contactor_state/domain/entities/vcu_contactor_state_entity.dart';
import '../../../shared/vcu_pdu_status/domain/entities/vcu_pdu_status_entity.dart';
import '../../../shared/vcu_power_subsystem_health/domain/entities/power_health_entity.dart';
import '../../../shared/vcu_subsystem_state/domain/entities/vcu_subsystem_info_entity.dart';
import '../../../shared/vcu_subsystem_power_state/domain/vcu_subsystem_power_state_entity.dart';
import '../../../shared/vcu_contactor_state/enums/contactor_fault_enum.dart';
import '../../../shared/vcu_pdu_status/enums/pdu_channel_state_enum.dart';
import '../../../shared/vcu_power_subsystem_health/enums/power_subsystem_status.dart';
import '../../../shared/vcu_subsystem_power_state/domain/power_state_enum.dart';
import '../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../core/theme/app_colors.dart';

class PowerItem {
  final String label;
  final Color? color;
  const PowerItem(this.label, [this.color]);
  bool get isHeader => color == null;
}

class PowerState {
  final VcuContactorStateEntity? contactorState;
  final VcuPduStatusEntity? vcuPduStatus;
  final PowerHealthEntity? powerHealth;
  final VcuSubsystemInfoEntity? subsystemInfo;
  final VcuSubsystemPowerStateEntity? subsystemPowerState;

  const PowerState({
    this.contactorState,
    this.vcuPduStatus,
    this.powerHealth,
    this.subsystemInfo,
    this.subsystemPowerState,
  });

  bool get isLoading => [
        contactorState,
        vcuPduStatus,
        powerHealth,
        subsystemInfo,
        subsystemPowerState,
      ].every((e) => e == null);

  List<PowerItem> get hvPduItems {
    final isOn = subsystemPowerState?.hvPdu == PowerStateEnum.on;
    return [
      _row('Power Status', subsystemPowerState?.hvPdu),
      _row('Overall Health', isOn ? subsystemInfo?.hvPdu : null),
      _row('Pre-charge contactor', isOn ? contactorState?.preChargeContFault : null),
      _row('Motor Ctrl contactor', isOn ? contactorState?.mcContFault : null),
      _row('I/P LV contactor', isOn ? contactorState?.ipDcDcContFault : null),
      _row('HV Charging contactor', isOn ? contactorState?.hvChargeContFault : null),
      _row('LV Charging contactor', isOn ? contactorState?.lvChargeContFault : null),
      _row('O/P LV contactor', isOn ? contactorState?.opDcDcContFault : null),
    ];
  }

  List<PowerItem> get dcDcItems {
    final isOn = subsystemPowerState?.dcDc == PowerStateEnum.on;
    return [
      _row('Power Status', subsystemPowerState?.dcDc),
      _row('Overall Health', isOn ? subsystemInfo?.dcDc48v12v : null),
    ];
  }

  List<PowerItem> get lightItems => [
        _row('Head lights', subsystemPowerState?.headLights),
        _row('Rear lights', subsystemPowerState?.aftLights),
        _row('Fog lights', subsystemPowerState?.fogLights),
      ];

  List<PowerItem> get hvBatteryItems {
    final hb = powerHealth?.hvBattery;
    return [
      _row('Overall Health', subsystemInfo?.hvBattery),
      const PowerItem('Voltage Faults'),
      _row('Cell Over-voltage', hb?.singleCellOvervoltage),
      _row('Cell Under-voltage', hb?.singleCellUndervoltage),
      _row('Pack Over-voltage', hb?.packOvervoltage),
      _row('Pack Under-voltage', hb?.packUndervoltage),
      const PowerItem('Temperature Faults'),
      _row('Charge Over-temperature', hb?.chargeOverTemperature),
      _row('Charge Low-temperature', hb?.chargeLowTemperature),
      _row('Discharge Over-temperature', hb?.dischargeOverTemperature),
      _row('Discharge Low-temperature', hb?.dischargeLowTemperature),
      const PowerItem('Current Faults'),
      _row('Charge Over-current', hb?.chargeOvercurrent),
      _row('Discharge Over-current', hb?.dischargeOvercurrent),
      _row('Short Circuit', hb?.shortCircuitProtection),
      const PowerItem('BMS hardware faults'),
      _row('Front-End IC Error', hb?.frontDetectionIcError),
      _row('Software MOS Lock', hb?.softwareLockMos),
      const PowerItem('Aging faults'),
      _row('Cycle life fault', hb?.cycleLifeFault),
      _row('Capacity fault', hb?.capacityFault),
    ];
  }

  List<PowerItem> get lvPduItems {
    final isOn = subsystemPowerState?.lvPdu == PowerStateEnum.on;
    return [
      _row('Power Status', subsystemPowerState?.lvPdu),
      _row('Overall Health', isOn ? subsystemInfo?.lvPdu : null),
      _row('CH1 fault', isOn ? vcuPduStatus?.channel1State : null),
      _row('CH2 fault', isOn ? vcuPduStatus?.channel2State : null),
      _row('CH3 fault', isOn ? vcuPduStatus?.channel3State : null),
      _row('CH4 fault', isOn ? vcuPduStatus?.channel4State : null),
      _row('CH5 fault', isOn ? vcuPduStatus?.channel5State : null),
      _row('CH6 fault', isOn ? vcuPduStatus?.channel6State : null),
      _row('CH7 fault', isOn ? vcuPduStatus?.channel7State : null),
      _row('CH8 fault', isOn ? vcuPduStatus?.channel8State : null),
    ];
  }

  List<PowerItem> get lvBatteryItems {
    final lb = powerHealth?.lvBattery;
    return [
      _row('Overall Health', subsystemInfo?.lvBattery),
      _row('Battery Deeply Discharged', lb?.deepDischarge),
      _row('Under-voltage', lb?.underVoltage),
      _row('Over-voltage', lb?.overVoltage),
      _row('Load-fault', lb?.loadFault),
    ];
  }

  PowerItem _row(String label, Object? state) {
    final color = switch (state) {
      PowerStateEnum.on ||
      SubsystemFaultState.healthy ||
      ContactorState.healthy ||
      PowerSubsystemStatus.healthy ||
      PduChannelState.healthy =>
        AppColors.healthy,
      PowerStateEnum.off ||
      SubsystemFaultState.faulty ||
      ContactorState.faulty ||
      PowerSubsystemStatus.fault ||
      PduChannelState.fault =>
        AppColors.faulty,
      _ => AppColors.unknown,
    };
    return PowerItem(label, color);
  }

}
