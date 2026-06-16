import 'package:flutter/material.dart';
import '../../../../core/constants/subsystem_list_constants.dart';
import '../../../../shared/comp_radio_state/domain/entities/comp_radio_state_entity.dart';
import '../../../../core/enums/subsystem_status_enum.dart';
import '../../../../shared/vcu_subsystem_state/domain/entities/system_info_entity.dart';

class SystemScreenState {
  final SystemInfoEntity? systemInfo;
  final DateTime? systemInfoLastUpdate;
  
  final CompRadioState? computeCommInfo;
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
    CompRadioState? computeCommInfo,
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
  Map<Subsystem, SubsystemStatus> get subsystemStatuses {
    const staleThreshold = Duration(seconds: 5);

    final bool systemStale = systemInfoLastUpdate == null || 
        now.difference(systemInfoLastUpdate!) > staleThreshold;
    
    final bool computeStale = computeInfoLastUpdate == null || 
        now.difference(computeInfoLastUpdate!) > staleThreshold;

    return {
      Subsystem.frontMotorController: !systemStale ? systemInfo!.frontMotorController : SubsystemStatus.unknown,
      Subsystem.rearMotorController: !systemStale ? systemInfo!.rearMotorController : SubsystemStatus.unknown,
      Subsystem.hvBattery: !systemStale ? systemInfo!.hvBattery : SubsystemStatus.unknown,
      Subsystem.lvBattery: !systemStale ? systemInfo!.lvBattery : SubsystemStatus.unknown,
      Subsystem.lvPdu: !systemStale ? systemInfo!.lvPdu : SubsystemStatus.unknown,
      Subsystem.dcDc48v12v: !systemStale ? systemInfo!.dcDc48v12v : SubsystemStatus.unknown,
      Subsystem.dcDc12v5v: !systemStale ? systemInfo!.dcDc12v5v : SubsystemStatus.unknown,
      Subsystem.vcu: !systemStale ? systemInfo!.vcu : SubsystemStatus.unknown,
      Subsystem.frontLeftMotor: !systemStale ? systemInfo!.frontLeftMotor : SubsystemStatus.unknown,
      Subsystem.rearLeftMotor: !systemStale ? systemInfo!.rearLeftMotor : SubsystemStatus.unknown,
      Subsystem.frontRightMotor: !systemStale ? systemInfo!.frontRightMotor : SubsystemStatus.unknown,
      Subsystem.rearRightMotor: !systemStale ? systemInfo!.rearRightMotor : SubsystemStatus.unknown,
      Subsystem.compute: !systemStale ? systemInfo!.compute : SubsystemStatus.unknown,
      Subsystem.uhfRadio: !computeStale ? computeCommInfo!.uhfRadio : SubsystemStatus.unknown,
      Subsystem.lBandRadio: !computeStale ? computeCommInfo!.lBandRadio : SubsystemStatus.unknown,
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
      Subsystem.dcDc48v12v => 'DC-DC\n48V-12V',
      Subsystem.dcDc12v5v => 'DC-DC\n12V-5V',
      Subsystem.vcu => 'VCU',
      Subsystem.frontLeftMotor => 'FORWARD LEFT\nMOTOR',
      Subsystem.rearLeftMotor => 'REAR LEFT\nMOTOR',
      Subsystem.frontRightMotor => 'FORWARD RIGHT\nMOTOR',
      Subsystem.rearRightMotor => 'REAR RIGHT\nMOTOR',
      Subsystem.uhfRadio => 'UHF RADIO',
      Subsystem.lBandRadio => 'L BAND RADIO',
      Subsystem.compute => 'COMPUTE',
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
      Subsystem.hvBattery => Icons.battery_charging_full,
      Subsystem.lvBattery => Icons.battery_std,
      Subsystem.frontMotorController ||
      Subsystem.rearMotorController =>
        Icons.settings_outlined,
      Subsystem.dcDc48v12v => Icons.ev_station,
      Subsystem.dcDc12v5v => Icons.bolt,
      Subsystem.compute => Icons.computer,
      Subsystem.uhfRadio => Icons.settings_input_antenna,
      Subsystem.lBandRadio => Icons.radar,
    };
  }

  (Color, String) getVisuals(Subsystem subsystem) {
    final status = subsystemStatuses[subsystem] ?? SubsystemStatus.unknown;
    return switch (status) {
      SubsystemStatus.healthy => (const Color(0xFF00FF66), 'Healthy'),
      SubsystemStatus.unhealthy => (const Color(0xFFFF3B3B), 'Fault Detected'),
      SubsystemStatus.noCommunication => (const Color(0xFF93A9B5), 'Not Connected'),
      SubsystemStatus.unknown => (Colors.white24, 'Unknown'),
    };
  }

  bool isStatusActive(Subsystem subsystem) {
    final status = subsystemStatuses[subsystem] ?? SubsystemStatus.unknown;
    return status == SubsystemStatus.healthy || status == SubsystemStatus.unhealthy;
  }
}
