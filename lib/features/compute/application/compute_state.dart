import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../shared/sec_comp_hw_health/domain/sec_compute_status_enum.dart';
import '../../../shared/vcu_comp_info/domain/vcu_comp_info_entity.dart';
import '../../../shared/sec_comp_hw_health/domain/sec_compute_health_entity.dart';
import '../../../shared/vcu_interface_health/domain/vcu_interface_health_entity.dart';
import '../../../shared/vcu_subsystem_state/domain/entities/vcu_subsystem_info_entity.dart';
import '../../../shared/vcu_subsystem_power_state/domain/vcu_subsystem_power_state_entity.dart';
import '../../../shared/vcu_comp_info/domain/vcu_comp_info_enum.dart';
import '../../../shared/vcu_interface_health/domain/vcu_can_status_enum.dart';
import '../../../shared/vcu_interface_health/domain/vcu_fault_state_enum.dart';
import '../../../shared/vcu_subsystem_power_state/domain/power_state_enum.dart';

class ComputeItem {
  final String label;
  final Color? color;
  const ComputeItem(this.label, [this.color]);
  bool get isHeader => color == null;
}

class ComputeTileState {
  final String title;
  final List<ComputeItem> items;

  const ComputeTileState({
    required this.title,
    required this.items,
  });
}

class ComputeScreenState {
  final VcuCompInfoEntity? mainCompInfo;
  final SecComputeHealthEntity? secCompInfo;
  final VcuInterfaceHealthEntity? vcuInfo;
  final VcuSubsystemInfoEntity? subsystemInfo;
  final VcuSubsystemPowerStateEntity? powerState;

  const ComputeScreenState({
    this.mainCompInfo,
    this.secCompInfo,
    this.vcuInfo,
    this.subsystemInfo,
    this.powerState,
  });

  bool get isLoading =>
      mainCompInfo == null &&
      secCompInfo == null &&
      vcuInfo == null &&
      subsystemInfo == null &&
      powerState == null;

  List<ComputeTileState> get tiles => [
        _mainComputeTile,
        _secondaryComputeTile,
        _vcuTile,
      ];

  ComputeTileState get _mainComputeTile {
    final m = mainCompInfo;
    final isOn = powerState?.mainComp == PowerStateEnum.on;
    return ComputeTileState(
      title: 'Main Compute',
      items: [
        _row('Power Status', powerState?.mainComp),
        _row('Overall Health', isOn ? subsystemInfo?.mainCompute : null),
        _row('Jetson Heartbeat', isOn ? m?.jetsonHeartbeat : null),
        _row('Temperature Fault', isOn ? m?.tempFault : null),
        _row('Voltage Fault', isOn ? m?.voltFault : null),
        _row('CPU Load Fault', isOn ? m?.cpuLoadFault : null),
      ],
    );
  }

  ComputeTileState get _secondaryComputeTile {
    final s = secCompInfo;
    final isOn = powerState?.secComp == PowerStateEnum.on;
    return ComputeTileState(
      title: 'Secondary Compute',
      items: [
        _row('Power Status', powerState?.secComp),
        _row('Overall Health', isOn ? s?.computeState : null),
        const ComputeItem('Internal Health'),
        _secComputeRow('CPU Load Fault', isOn ? s?.cpuLoadFault : null),
        _secComputeRow('Memory Fault', isOn ? s?.memoryFault : null),
        _secComputeRow('Storage Fault', isOn ? s?.storageFault : null),
        const ComputeItem('Interfaces'),
        _secInterfaceRow('Control CAN', isOn ? s?.controlCanStatus : null),
        _secInterfaceRow('Aux CAN', isOn ? s?.auxCanStatus : null),
        _secInterfaceRow('Actuator CAN', isOn ? s?.actCanStatus : null),
        _secInterfaceRow('Forward MC Serial', isOn ? s?.forwardMcSerialStatus : null),
        _secInterfaceRow('Aft MC Serial', isOn ? s?.aftMcSerialStatus : null),
        _secInterfaceRow('Ethernet Status', isOn ? s?.ethernetStatus : null),
      ],
    );
  }

  ComputeTileState get _vcuTile {
    final v = vcuInfo;
    final isOn = powerState?.vcu == PowerStateEnum.on;
    return ComputeTileState(
      title: 'VCU',
      items: [
        _row('Power Status', powerState?.vcu),
        _row('Overall Health', isOn ? subsystemInfo?.vcu : null),
        const ComputeItem('CAN Bus Status'),
        _row('CAN A Bus-off', isOn ? v?.canABusOff : null),
        _row('CAN B Bus-off', isOn ? v?.canBBusOff : null),
        _row('CAN C Bus-off', isOn ? v?.canCBusOff : null),
        const ComputeItem('Interface Faults'),
        _row('Discrete Interface Fault', isOn ? v?.discreteInputsFault : null),
        _row('Analog Interface Fault', isOn ? v?.analogInputsFault : null),
        _row('High Side Drivers Fault', isOn ? v?.highSideDriversFault : null),
        _row('Low Side Drivers Fault', isOn ? v?.lowSideDriversFault : null),
        const ComputeItem('System Health'),
        _row('Supply Voltage Fault', isOn ? v?.supplyVoltageFault : null),
        _row('MCU Watchdog Fault', isOn ? v?.mcuWatchdogFault : null),
        _row('CPU Overload', isOn ? v?.cpuOverload : null),
        _row('RAM Fault', isOn ? v?.ramFault : null),
        _row('Flash CRC Failure', isOn ? v?.flashCrcFailure : null),
        _row('Internal Temperature Fault', isOn ? v?.internalTempFault : null),
        const ComputeItem('Other'),
        _row('FCC Active', isOn ? v?.fccActive : null),
        _row('Safety SBC Fault', isOn ? v?.safetySbcFault : null),
        _row('Boot Failure', isOn ? v?.bootFailure : null),
      ],
    );
  }

  ComputeItem _row(String label, Object? state) {
    if (state == null) return ComputeItem(label, AppColors.unknown);
    
    final color = switch (state) {
      PowerStateEnum.on ||
      SubsystemFaultState.healthy ||
      VcuCompInfoStatus.healthy ||
      VcuCanStatus.on ||
      VcuFaultState.healthy =>
        AppColors.healthy,
      PowerStateEnum.off ||
      SubsystemFaultState.faulty ||
      VcuCompInfoStatus.fault ||
      VcuCanStatus.off ||
      VcuFaultState.fault =>
        AppColors.faulty,
      _ => AppColors.unknown,
    };
    return ComputeItem(label, color);
  }

  ComputeItem _secComputeRow(String label, SecComputeStatus? state) {
    if (state == null) return ComputeItem(label, AppColors.unknown);

    final color = switch (state) {
      SecComputeStatus.healthy => AppColors.healthy,
      SecComputeStatus.fault => AppColors.faulty,
      SecComputeStatus.unknown => AppColors.unknown,
    };
    return ComputeItem(label, color);
  }

  ComputeItem _secInterfaceRow(String label, SecInterfaceStatus? state) {
    if (state == null) return ComputeItem(label, AppColors.unknown);

    final color = switch (state) {
      SecInterfaceStatus.active => AppColors.healthy,
      SecInterfaceStatus.inactive => AppColors.faulty,
      SecInterfaceStatus.unknown => AppColors.unknown,
    };
    return ComputeItem(label, color);
  }
}
