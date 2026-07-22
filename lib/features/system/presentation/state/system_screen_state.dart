import 'package:flutter/material.dart';
import 'package:scout_obd/shared/sec_comp_hw_health/domain/sec_compute_health_entity.dart';

import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../../core/constants/subsystem_list_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/vcu_status/domain/vcu_status_enums.dart';
import '../../../../shared/vcu_status/domain/vcu_status_entity.dart';
import '../../../../shared/vcu_subsystem_state/domain/entities/vcu_subsystem_info_entity.dart';
import '../../../../shared/comp_subsystem_state/domain/entities/comp_subsystem_state_entity.dart';

class StageData {
  final String title;
  final Color titleColor;
  final List<Subsystem> items;

  const StageData({
    required this.title,
    required this.titleColor,
    required this.items,
  });
}

// TODO: Remove special handling of GNSS after ICD gets updated
class SystemScreenState {
  final VcuSubsystemInfoEntity? systemInfo;
  final CompSubsystemStateEntity? computeCommInfo;
  final SecComputeHealthEntity? secComputeInfo;
  final VcuStatusEntity? vcuStatus;

  const SystemScreenState({
    this.systemInfo,
    this.computeCommInfo,
    this.vcuStatus,
    this.secComputeInfo
  });

  SystemScreenState copyWith({
    VcuSubsystemInfoEntity? systemInfo,
    CompSubsystemStateEntity? computeCommInfo,
    VcuStatusEntity? vcuStatus,
    SecComputeHealthEntity? secComputeInfo,
  }) {
    return SystemScreenState(
      systemInfo: systemInfo ?? this.systemInfo,
      computeCommInfo: computeCommInfo ?? this.computeCommInfo,
      vcuStatus: vcuStatus ?? this.vcuStatus,
      secComputeInfo: secComputeInfo ?? this.secComputeInfo,
    );
  }

  /// Calculates the current display status for all subsystems.
  Map<Subsystem, dynamic> get subsystemStatuses {
    return {
      Subsystem.forwardMotorController: systemInfo?.forwardMotorController ?? SubsystemFaultState.unknown,
      Subsystem.aftMotorController: systemInfo?.aftMotorController ?? SubsystemFaultState.unknown,
      Subsystem.hvBattery: systemInfo?.hvBattery ?? SubsystemFaultState.unknown,
      Subsystem.lvBattery: systemInfo?.lvBattery ?? SubsystemFaultState.unknown,
      Subsystem.lvPdu: systemInfo?.lvPdu ?? SubsystemFaultState.unknown,
      Subsystem.hvPdu: systemInfo?.hvPdu ?? SubsystemFaultState.unknown,
      Subsystem.dcDc48v12v: systemInfo?.dcDc48v12v ?? SubsystemFaultState.unknown,
      Subsystem.vcu: systemInfo?.vcu ?? SubsystemFaultState.unknown,
      Subsystem.forwardPortMotor: systemInfo?.forwardPortMotor ?? SubsystemFaultState.unknown,
      Subsystem.aftPortMotor: systemInfo?.aftPortMotor ?? SubsystemFaultState.unknown,
      Subsystem.forwardStarboardMotor: systemInfo?.forwardStarboardMotor ?? SubsystemFaultState.unknown,
      Subsystem.aftStarboardMotor: systemInfo?.aftStarboardMotor ?? SubsystemFaultState.unknown,
      Subsystem.mainCompute: systemInfo?.mainCompute ?? SubsystemFaultState.unknown,
      Subsystem.secondaryCompute: secComputeInfo?.computeState ?? SubsystemFaultState.unknown,
      Subsystem.uhfRadio: computeCommInfo?.uhfRadio ?? SubsystemFaultState.unknown,
      Subsystem.lBandRadio: computeCommInfo?.lBandRadio ?? SubsystemFaultState.unknown,
      Subsystem.ethernetSwitch: computeCommInfo?.ethernetSwitchFault ?? SubsystemFaultState.unknown,
      Subsystem.gnss: computeCommInfo?.gnssFault ?? GnssFaultState.unknown,
      Subsystem.imu: computeCommInfo?.imuFault ?? SubsystemFaultState.unknown,
      Subsystem.lidar2d: computeCommInfo?.lidar2dFault ?? SubsystemFaultState.unknown,
      Subsystem.lidar3d: computeCommInfo?.lidar3dFault ?? SubsystemFaultState.unknown,
    };
  }

  // --- UI Transformation Getters & Methods ---

  String getLabel(Subsystem subsystem) {
    return switch (subsystem) {
      Subsystem.forwardMotorController => 'FORWARD MOTOR\nCONTROLLER',
      Subsystem.aftMotorController => 'AFT MOTOR\nCONTROLLER',
      Subsystem.hvBattery => 'HV BATTERY',
      Subsystem.lvBattery => 'LV BATTERY',
      Subsystem.lvPdu => 'LV PDU',
      Subsystem.hvPdu => 'HV PDU',
      Subsystem.dcDc48v12v => 'DC-DC\n48V-12V',
      Subsystem.vcu => 'VCU',
      Subsystem.forwardPortMotor => 'FORWARD PORT\nMOTOR',
      Subsystem.aftPortMotor => 'AFT PORT\nMOTOR',
      Subsystem.forwardStarboardMotor => 'FORWARD\nSTARBOARD\nMOTOR',
      Subsystem.aftStarboardMotor => 'AFT STARBOARD\nMOTOR',
      Subsystem.uhfRadio => 'UHF RADIO',
      Subsystem.lBandRadio => 'L BAND RADIO',
      Subsystem.mainCompute => 'MAIN COMPUTE',
      Subsystem.secondaryCompute => 'SECONDARY\nCOMPUTE',
      Subsystem.ethernetSwitch => 'ETHERNET\nSWITCH',
      Subsystem.gnss => 'GNSS',
      Subsystem.imu => 'IMU',
      Subsystem.lidar2d => '2D LIDAR',
      Subsystem.lidar3d => '3D LIDAR',
    };
  }

  IconData getIcon(Subsystem subsystem) {
    return switch (subsystem) {
      Subsystem.forwardPortMotor ||
      Subsystem.forwardStarboardMotor ||
      Subsystem.aftPortMotor ||
      Subsystem.aftStarboardMotor =>
        Icons.settings_suggest,
      Subsystem.vcu => Icons.developer_board,
      Subsystem.lvPdu => Icons.power,
      Subsystem.hvPdu => Icons.power_outlined,
      Subsystem.hvBattery => Icons.battery_charging_full,
      Subsystem.lvBattery => Icons.battery_std,
      Subsystem.forwardMotorController ||
      Subsystem.aftMotorController =>
        Icons.settings_outlined,
      Subsystem.dcDc48v12v => Icons.ev_station,
      Subsystem.mainCompute || Subsystem.secondaryCompute => Icons.computer,
      Subsystem.uhfRadio => Icons.settings_input_antenna,
      Subsystem.lBandRadio => Icons.radar,
      Subsystem.ethernetSwitch => Icons.router,
      Subsystem.gnss => Icons.gps_fixed,
      Subsystem.imu => Icons.compass_calibration,
      Subsystem.lidar2d || Subsystem.lidar3d => Icons.sensors,
    };
  }

  (Color, String) getVisuals(Subsystem subsystem) {
    final status = subsystemStatuses[subsystem];

    if (status is GnssFaultState) {
      return switch (status) {
        GnssFaultState.healthy => (AppColors.healthy, 'Healthy'),
        GnssFaultState.degraded => (AppColors.degraded, 'Degraded'),
        GnssFaultState.faulty => (AppColors.faulty, 'Faulty'),
        GnssFaultState.unknown => (AppColors.unknown, 'Unknown'),
      };
    }

    final faultStatus = status as SubsystemFaultState? ?? SubsystemFaultState.unknown;
    return switch (faultStatus) {
      SubsystemFaultState.healthy => (AppColors.healthy, 'Healthy'),
      SubsystemFaultState.faulty => (AppColors.faulty, 'Faulty'),
      SubsystemFaultState.unknown => (AppColors.unknown, 'Unknown'),
    };
  }

  bool isStatusActive(Subsystem subsystem) {
    final status = subsystemStatuses[subsystem];

    if (status is GnssFaultState) {
      return status != GnssFaultState.unknown;
    }

    return status == SubsystemFaultState.healthy || status == SubsystemFaultState.faulty;
  }

  List<StageData> get stages {
    final opState = vcuStatus?.operationalState;
    final inactiveColor = AppColors.textDisabled.withOpacity(0.5);
    const activeColor = AppColors.healthy;

    return [
      StageData(
        title: 'STAGE 1: IDLE',
        titleColor: opState == VcuOperationalState.idle ? activeColor : inactiveColor,
        items: const [
          Subsystem.vcu,
          Subsystem.hvBattery,
          Subsystem.lvBattery,
          Subsystem.secondaryCompute,
        ],
      ),
      StageData(
        title: 'STAGE 2: KEY ON',
        titleColor: opState == VcuOperationalState.keyOn ? activeColor : inactiveColor,
        items: const [
          Subsystem.dcDc48v12v,
          Subsystem.lvPdu,
          Subsystem.hvPdu,
          Subsystem.mainCompute,
          Subsystem.uhfRadio,
          Subsystem.lBandRadio,
          Subsystem.ethernetSwitch,
          Subsystem.gnss,
          Subsystem.imu,
          Subsystem.lidar2d,
          Subsystem.lidar3d,
        ],
      ),
      StageData(
        title: 'STAGE 3: DRIVE ON',
        titleColor: opState == VcuOperationalState.drive ? activeColor : inactiveColor,
        items: const [
          Subsystem.forwardMotorController,
          Subsystem.aftMotorController,
          Subsystem.forwardPortMotor,
          Subsystem.forwardStarboardMotor,
          Subsystem.aftPortMotor,
          Subsystem.aftStarboardMotor,
        ],
      ),
    ];
  }
}
