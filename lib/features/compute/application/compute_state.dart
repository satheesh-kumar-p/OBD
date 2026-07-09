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
    return ComputeTileState(
      title: 'Main Compute',
      items: [
        _row('Power Status', powerState?.mainComp),
        _row('Overall Health', subsystemInfo?.mainCompute),
        _row('Jetson Heartbeat', m?.jetsonHeartbeat),
        _row('Temperature Fault', m?.tempFault),
        _row('Voltage Fault', m?.voltFault),
        _row('CPU Load Fault', m?.cpuLoadFault),
      ],
    );
  }

  ComputeTileState get _secondaryComputeTile {
    final s = secCompInfo;
    return ComputeTileState(
      title: 'Secondary Compute',
      items: [
        _row('Power Status', powerState?.secComp),
        _row('Overall Health', s?.computeState),
        const ComputeItem('Internal Health'),
        _secComputeRow('CPU Load Fault', s?.cpuLoadFault),
        _secComputeRow('Memory Fault', s?.memoryFault),
        _secComputeRow('Storage Fault', s?.storageFault),
        const ComputeItem('Interfaces'),
        _secInterfaceRow('Control CAN', s?.controlCanStatus),
        _secInterfaceRow('Aux CAN', s?.auxCanStatus),
        _secInterfaceRow('Actuator CAN', s?.actCanStatus),
        _secInterfaceRow('Forward MC Serial', s?.forwardMcSerialStatus),
        _secInterfaceRow('Aft MC Serial', s?.aftMcSerialStatus),
        _secInterfaceRow('Ethernet Status', s?.ethernetStatus),
      ],
    );
  }

  ComputeTileState get _vcuTile {
    final v = vcuInfo;
    return ComputeTileState(
      title: 'VCU',
      items: [
        _row('Power Status', powerState?.vcu),
        _row('Overall Health', subsystemInfo?.vcu),
        const ComputeItem('CAN Bus Status'),
        _row('CAN A Bus-off', v?.canABusOff),
        _row('CAN B Bus-off', v?.canBBusOff),
        _row('CAN C Bus-off', v?.canCBusOff),
        const ComputeItem('Interface Faults'),
        _row('Discrete Interface Fault', v?.discreteInputsFault),
        _row('Analog Interface Fault', v?.analogInputsFault),
        _row('High Side Drivers Fault', v?.highSideDriversFault),
        _row('Low Side Drivers Fault', v?.lowSideDriversFault),
        const ComputeItem('System Health'),
        _row('Supply Voltage Fault', v?.supplyVoltageFault),
        _row('MCU Watchdog Fault', v?.mcuWatchdogFault),
        _row('CPU Overload', v?.cpuOverload),
        _row('RAM Fault', v?.ramFault),
        _row('Flash CRC Failure', v?.flashCrcFailure),
        _row('Internal Temperature Fault', v?.internalTempFault),
        const ComputeItem('Other'),
        _row('FCC Active', v?.fccActive),
        _row('Safety SBC Fault', v?.safetySbcFault),
        _row('Boot Failure', v?.bootFailure),
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
