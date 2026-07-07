import 'package:flutter/material.dart';
import '../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/vcu_drive_motor_controller_health/domain/entities/drive_mc_information_entity.dart';
import '../../../shared/vcu_drive_motor_controller_health/domain/entities/motor_controller_information.dart';
import '../../../shared/vcu_drive_motor_controller_health/domain/entities/mc_status.dart';
import '../../../shared/vcu_drive_motor_health/domain/entities/drive_motor_information_entity.dart';
import '../../../shared/vcu_drive_motor_health/domain/entities/motor_information.dart';
import '../../../shared/vcu_drive_motor_health/domain/entities/motor_status.dart';
import '../../../shared/vcu_subsystem_power_state/domain/power_state_enum.dart';
import '../../../shared/vcu_subsystem_power_state/domain/vcu_subsystem_power_state_entity.dart';
import '../../../shared/vcu_subsystem_state/domain/entities/vcu_subsystem_info_entity.dart';

class DriveState {
  final DriveMotorInformationEntity? motorInfo;
  final DriveMcInformationEntity? mcInfo;
  final VcuSubsystemInfoEntity? subsystemInfo;
  final VcuSubsystemPowerStateEntity? powerInfo;

  const DriveState({
    this.motorInfo,
    this.mcInfo,
    this.subsystemInfo,
    this.powerInfo,
  });

  bool get isLoading =>
      motorInfo == null &&
      mcInfo == null &&
      subsystemInfo == null &&
      powerInfo == null;

  List<MotorStatusRowData> get motorRows {
    return [
      MotorStatusRowData(
        name: 'FORWARD\nPORT MOTOR',
        info: motorInfo?.forwardPortMotor,
        overall: subsystemInfo?.forwardPortMotor,
      ),
      MotorStatusRowData(
        name: 'FORWARD\nSTARBOARD\nMOTOR',
        info: motorInfo?.forwardStarboardMotor,
        overall: subsystemInfo?.forwardStarboardMotor,
      ),
      MotorStatusRowData(
        name: 'AFT PORT\nMOTOR',
        info: motorInfo?.aftPortMotor,
        overall: subsystemInfo?.aftPortMotor,
      ),
      MotorStatusRowData(
        name: 'AFT\nSTARBOARD\nMOTOR',
        info: motorInfo?.aftStarboardMotor,
        overall: subsystemInfo?.aftStarboardMotor,
      ),
    ];
  }

  List<ControllerStatusRowData> get controllerRows {
    return [
      ControllerStatusRowData.fromInfo(
        name: 'FORWARD\nMOTOR CTRL',
        info: mcInfo?.forwardMotorController,
        overall: subsystemInfo?.forwardMotorController,
        power: powerInfo?.forwardMc,
      ),
      ControllerStatusRowData.fromInfo(
        name: 'AFT MOTOR\nCTRL',
        info: mcInfo?.aftMotorController,
        overall: subsystemInfo?.aftMotorController,
        power: powerInfo?.aftMc,
      ),
    ];
  }

  DriveState copyWith({
    DriveMotorInformationEntity? motorInfo,
    bool clearMotorInfo = false,
    DriveMcInformationEntity? mcInfo,
    bool clearMcInfo = false,
    VcuSubsystemInfoEntity? subsystemInfo,
    bool clearSubsystemInfo = false,
    VcuSubsystemPowerStateEntity? powerInfo,
    bool clearPowerInfo = false,
  }) {
    return DriveState(
      motorInfo: clearMotorInfo ? null : (motorInfo ?? this.motorInfo),
      mcInfo: clearMcInfo ? null : (mcInfo ?? this.mcInfo),
      subsystemInfo:
          clearSubsystemInfo ? null : (subsystemInfo ?? this.subsystemInfo),
      powerInfo: clearPowerInfo ? null : (powerInfo ?? this.powerInfo),
    );
  }
}

class MotorStatusRowData {
  final String name;
  final List<Color> colors;

  static const List<String> columns = [
    'STATUS',
    'OVER\nSPEED',
    'OVER\nLOAD',
    'PHASE\nLOSS',
    'BRAKE',
    'ENCODER\nFAULT',
    'OVER\nTEMP',
    'HALL\nFAULT',
    'STALL'
  ];

  MotorStatusRowData({
    required this.name,
    MotorInformation? info,
    SubsystemFaultState? overall,
  }) : colors = [
          _getSubsystemStatusColor(overall),
          _getMotorStatusColor(info?.overSpeed),
          _getMotorStatusColor(info?.overload),
          _getMotorStatusColor(info?.phaseLoss),
          _getMotorStatusColor(info?.brake),
          _getMotorStatusColor(info?.encoderFault),
          _getMotorStatusColor(info?.overTemp),
          _getMotorStatusColor(info?.hallFault),
          _getMotorStatusColor(info?.stalled),
        ];
}

class ControllerStatusRowData {
  final String name;
  final List<Color> colors;

  static const List<String> columns = [
    'POWER',
    'STATUS',
    'DRIVE',
    'OVER\nCURR',
    'OVER\nVOLT',
    'UNDER\nVOLT',
    'OVER\nTEMP',
    'CAN\nCOMM',
    'UART\nCOMM',
    'BUS\nVOLT'
  ];

  ControllerStatusRowData({
    required this.name,
    required this.colors,
  });

  factory ControllerStatusRowData.fromInfo({
    required String name,
    MotorControllerInformation? info,
    SubsystemFaultState? overall,
    PowerState? power,
  }) {
    return ControllerStatusRowData(
      name: name,
      colors: [
        _getPowerStatusColor(power),
        _getSubsystemStatusColor(overall),
        _getMcStatusColor(info?.drive),
        _getMcStatusColor(info?.overCurrent),
        _getMcStatusColor(info?.overVoltage),
        _getMcStatusColor(info?.underVoltage),
        _getMcStatusColor(info?.overTemperature),
        _getMcStatusColor(info?.canCommunication),
        _getMcStatusColor(info?.uartCommunication),
        _getMcStatusColor(info?.dcBusVoltage),
      ],
    );
  }
}

Color _getMotorStatusColor(MotorStatus? status) {
  if (status == null) return AppColors.unknown;
  return status == MotorStatus.healthy ? AppColors.healthy : AppColors.faulty;
}

Color _getMcStatusColor(McStatus? status) {
  if (status == null) return AppColors.unknown;
  return status == McStatus.healthy ? AppColors.healthy : AppColors.faulty;
}

Color _getSubsystemStatusColor(SubsystemFaultState? status) {
  if (status == null) return AppColors.unknown;
  switch (status) {
    case SubsystemFaultState.healthy:
      return AppColors.healthy;
    case SubsystemFaultState.faulty:
      return AppColors.faulty;
    case SubsystemFaultState.unknown:
      return AppColors.unknown;
  }
}

Color _getPowerStatusColor(PowerState? status) {
  if (status == null) return AppColors.unknown;
  switch (status) {
    case PowerState.on:
      return AppColors.healthy;
    case PowerState.off:
      return AppColors.faulty;
    case PowerState.unknown:
      return AppColors.unknown;
  }
}
