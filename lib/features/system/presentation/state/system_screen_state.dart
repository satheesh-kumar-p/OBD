import 'package:flutter/material.dart';

import '../../../../core/constants/subsystem_list_constants.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../../shared/comp_subsystem_state/domain/entities/comp_subsystem_state_entity.dart';
import '../../../../shared/vcu_subsystem_state/domain/entities/system_info_entity.dart';

class SystemScreenState {
  final SystemInfoEntity? systemInfo;
  final DateTime? systemInfoLastUpdate;
  
  final CompSubsystemState? computeCommInfo;
  final DateTime? computeInfoLastUpdate;
  
  /// The reference time for staleness calculations in this state frame.
  final DateTime now;

  SystemScreenState({
    this.systemInfo,
    this.systemInfoLastUpdate,
    this.computeCommInfo,
    this.computeInfoLastUpdate,
    DateTime? now,
  }) : now = now ?? DateTime.now();

  SystemScreenState copyWith({
    SystemInfoEntity? systemInfo,
    DateTime? systemInfoLastUpdate,
    CompSubsystemState? computeCommInfo,
    DateTime? computeInfoLastUpdate,
    DateTime? now,
  }) {
    return SystemScreenState(
      systemInfo: systemInfo ?? this.systemInfo,
      systemInfoLastUpdate: systemInfoLastUpdate ?? this.systemInfoLastUpdate,
      computeCommInfo: computeCommInfo ?? this.computeCommInfo,
      computeInfoLastUpdate: computeInfoLastUpdate ?? this.computeInfoLastUpdate,
      now: now ?? this.now,
    );
  }

  /// Calculates the current display status for all subsystems,
  /// accounting for data staleness (5-second timeout).
  Map<Subsystem, SubsystemFaultState> get subsystemStatuses {
    const staleThreshold = Duration(seconds: 5);

    final bool systemStale = systemInfoLastUpdate == null || 
        now.difference(systemInfoLastUpdate!) > staleThreshold;
    
    final bool computeStale = computeInfoLastUpdate == null || 
        now.difference(computeInfoLastUpdate!) > staleThreshold;

    return {
      Subsystem.frontMotorController: !systemStale ? systemInfo!.frontMotorController : SubsystemFaultState.badValue,
      Subsystem.rearMotorController: !systemStale ? systemInfo!.rearMotorController : SubsystemFaultState.badValue,
      Subsystem.hvBattery: !systemStale ? systemInfo!.hvBattery : SubsystemFaultState.badValue,
      Subsystem.lvBattery: !systemStale ? systemInfo!.lvBattery : SubsystemFaultState.badValue,
      Subsystem.lvPdu: !systemStale ? systemInfo!.lvPdu : SubsystemFaultState.badValue,
      Subsystem.hvPdu: !systemStale ? systemInfo!.hvPdu : SubsystemFaultState.badValue,
      Subsystem.dcDc48v12v: !systemStale ? systemInfo!.dcDc48v12v : SubsystemFaultState.badValue,
      Subsystem.dcDc12v5v: !systemStale ? systemInfo!.dcDc12v5v : SubsystemFaultState.badValue,
      Subsystem.vcu: !systemStale ? systemInfo!.vcu : SubsystemFaultState.badValue,
      Subsystem.frontLeftMotor: !systemStale ? systemInfo!.frontLeftMotor : SubsystemFaultState.badValue,
      Subsystem.rearLeftMotor: !systemStale ? systemInfo!.rearLeftMotor : SubsystemFaultState.badValue,
      Subsystem.frontRightMotor: !systemStale ? systemInfo!.frontRightMotor : SubsystemFaultState.badValue,
      Subsystem.rearRightMotor: !systemStale ? systemInfo!.rearRightMotor : SubsystemFaultState.badValue,
      Subsystem.mainCompute: !systemStale ? systemInfo!.mainCompute : SubsystemFaultState.badValue,
      Subsystem.secondaryCompute: !systemStale ? systemInfo!.secondaryCompute : SubsystemFaultState.badValue,
      Subsystem.uhfRadio: !computeStale ? computeCommInfo!.uhfRadio : SubsystemFaultState.badValue,
      Subsystem.lBandRadio: !computeStale ? computeCommInfo!.lBandRadio : SubsystemFaultState.badValue,
      Subsystem.ethernetSwitch: !computeStale ? computeCommInfo!.ethernetSwitchFault : SubsystemFaultState.badValue,
      Subsystem.gnss: !computeStale ? computeCommInfo!.gnssFault : SubsystemFaultState.badValue,
      Subsystem.imu: !computeStale ? computeCommInfo!.imuFault : SubsystemFaultState.badValue,
      Subsystem.lidar2d: !computeStale ? computeCommInfo!.lidar2dFault : SubsystemFaultState.badValue,
      Subsystem.lidar3d: !computeStale ? computeCommInfo!.lidar3dFault : SubsystemFaultState.badValue,
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
      SubsystemFaultState.unknown => (const Color(0xFF93A9B5), 'Not Connected'),
      SubsystemFaultState.badValue => (Colors.white24, '--'),
    };
  }

  bool isStatusActive(Subsystem subsystem) {
    final status = subsystemStatuses[subsystem] ?? SubsystemFaultState.unknown;
    return status == SubsystemFaultState.noFault || status == SubsystemFaultState.faulty;
  }
}
