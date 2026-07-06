import 'package:flutter/material.dart';

import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../../core/constants/subsystem_list_constants.dart';
import '../../../../shared/vcu_status/domain/vcu_status_enums.dart';
import '../../../../shared/vcu_status/domain/vcu_status_entity.dart';
import '../../../../shared/vcu_subsystem_state/domain/entities/system_info_entity.dart';
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

class SystemScreenState {
  final SystemInfoEntity? systemInfo;
  final CompSubsystemState? computeCommInfo;
  final VcuStatusEntity? vcuStatus;

  const SystemScreenState({
    this.systemInfo,
    this.computeCommInfo,
    this.vcuStatus,
  });

  SystemScreenState copyWith({
    SystemInfoEntity? systemInfo,
    CompSubsystemState? computeCommInfo,
    VcuStatusEntity? vcuStatus,
  }) {
    return SystemScreenState(
      systemInfo: systemInfo ?? this.systemInfo,
      computeCommInfo: computeCommInfo ?? this.computeCommInfo,
      vcuStatus: vcuStatus ?? this.vcuStatus,
    );
  }

  /// Calculates the current display status for all subsystems.
  Map<Subsystem, SubsystemFaultState> get subsystemStatuses {
    return {
      Subsystem.frontMotorController: systemInfo?.frontMotorController ?? SubsystemFaultState.unknown,
      Subsystem.rearMotorController: systemInfo?.rearMotorController ?? SubsystemFaultState.unknown,
      Subsystem.hvBattery: systemInfo?.hvBattery ?? SubsystemFaultState.unknown,
      Subsystem.lvBattery: systemInfo?.lvBattery ?? SubsystemFaultState.unknown,
      Subsystem.lvPdu: systemInfo?.lvPdu ?? SubsystemFaultState.unknown,
      Subsystem.hvPdu: systemInfo?.hvPdu ?? SubsystemFaultState.unknown,
      Subsystem.dcDc48v12v: systemInfo?.dcDc48v12v ?? SubsystemFaultState.unknown,
      Subsystem.dcDc12v5v: systemInfo?.dcDc12v5v ?? SubsystemFaultState.unknown,
      Subsystem.vcu: systemInfo?.vcu ?? SubsystemFaultState.unknown,
      Subsystem.frontLeftMotor: systemInfo?.frontLeftMotor ?? SubsystemFaultState.unknown,
      Subsystem.rearLeftMotor: systemInfo?.rearLeftMotor ?? SubsystemFaultState.unknown,
      Subsystem.frontRightMotor: systemInfo?.frontRightMotor ?? SubsystemFaultState.unknown,
      Subsystem.rearRightMotor: systemInfo?.rearRightMotor ?? SubsystemFaultState.unknown,
      Subsystem.mainCompute: systemInfo?.mainCompute ?? SubsystemFaultState.unknown,
      Subsystem.secondaryCompute: systemInfo?.secondaryCompute ?? SubsystemFaultState.unknown,
      Subsystem.uhfRadio: computeCommInfo?.uhfRadio ?? SubsystemFaultState.unknown,
      Subsystem.lBandRadio: computeCommInfo?.lBandRadio ?? SubsystemFaultState.unknown,
      Subsystem.ethernetSwitch: computeCommInfo?.ethernetSwitchFault ?? SubsystemFaultState.unknown,
      Subsystem.gnss: computeCommInfo?.gnssFault ?? SubsystemFaultState.unknown,
      Subsystem.imu: computeCommInfo?.imuFault ?? SubsystemFaultState.unknown,
      Subsystem.lidar2d: computeCommInfo?.lidar2dFault ?? SubsystemFaultState.unknown,
      Subsystem.lidar3d: computeCommInfo?.lidar3dFault ?? SubsystemFaultState.unknown,
    };
  }

  // --- UI Transformation Getters & Methods ---

  String getLabel(Subsystem subsystem) {
    return switch (subsystem) {
      Subsystem.frontMotorController => 'FRONT MOTOR\nCONTROLLER',
      Subsystem.rearMotorController => 'REAR MOTOR\nCONTROLLER',
      Subsystem.hvBattery => 'HV BATTERY',
      Subsystem.lvBattery => 'LV BATTERY',
      Subsystem.lvPdu => 'LV PDU',
      Subsystem.hvPdu => 'HV PDU',
      Subsystem.dcDc48v12v => 'DC-DC\n48V-12V',
      Subsystem.dcDc12v5v => 'DC-DC\n12V-5V',
      Subsystem.vcu => 'VCU',
      Subsystem.frontLeftMotor => 'FORWARD LEFT\nMOTOR',
      Subsystem.rearLeftMotor => 'REAR LEFT\nMOTOR',
      Subsystem.frontRightMotor => 'FORWARD RIGHT\nMOTOR',
      Subsystem.rearRightMotor => 'REAR RIGHT\nMOTOR',
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
      Subsystem.frontLeftMotor ||
      Subsystem.frontRightMotor ||
      Subsystem.rearLeftMotor ||
      Subsystem.rearRightMotor =>
        Icons.settings_suggest,
      Subsystem.vcu => Icons.developer_board,
      Subsystem.lvPdu => Icons.power,
      Subsystem.hvPdu => Icons.power_outlined,
      Subsystem.hvBattery => Icons.battery_charging_full,
      Subsystem.lvBattery => Icons.battery_std,
      Subsystem.frontMotorController ||
      Subsystem.rearMotorController =>
        Icons.settings_outlined,
      Subsystem.dcDc48v12v => Icons.ev_station,
      Subsystem.dcDc12v5v => Icons.bolt,
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
    final status = subsystemStatuses[subsystem] ?? SubsystemFaultState.unknown;
    return switch (status) {
      SubsystemFaultState.noFault => (const Color(0xFF00FF66), 'Healthy'),
      SubsystemFaultState.faulty => (const Color(0xFFFF3B3B), 'Fault Detected'),
      SubsystemFaultState.unknown => (const Color(0xFF93A9B5), 'Unknown'),
    };
  }

  bool isStatusActive(Subsystem subsystem) {
    final status = subsystemStatuses[subsystem] ?? SubsystemFaultState.unknown;
    return status == SubsystemFaultState.noFault || status == SubsystemFaultState.faulty;
  }

  List<StageData> get stages {
    final opState = vcuStatus?.operationalState;
    final inactiveColor = Colors.white.withOpacity(0.5);
    const activeColor = Color(0xFF00FF66);

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
          Subsystem.mainCompute,
          Subsystem.uhfRadio,
          Subsystem.lBandRadio,
          Subsystem.dcDc12v5v,
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
          Subsystem.frontMotorController,
          Subsystem.rearMotorController,
          Subsystem.frontLeftMotor,
          Subsystem.frontRightMotor,
          Subsystem.rearLeftMotor,
          Subsystem.rearRightMotor,
        ],
      ),
    ];
  }
}
