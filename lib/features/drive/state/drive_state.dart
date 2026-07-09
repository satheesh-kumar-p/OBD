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
    final forwardMcOn = powerInfo?.forwardMc == PowerStateEnum.on;
    final aftMcOn = powerInfo?.aftMc == PowerStateEnum.on;

    return [
      MotorStatusRowData(
        name: 'FORWARD\nPORT MOTOR',
        info: forwardMcOn ? motorInfo?.forwardPortMotor : null,
        overall: forwardMcOn ? subsystemInfo?.forwardPortMotor : null,
      ),
      MotorStatusRowData(
        name: 'FORWARD\nSTARBOARD\nMOTOR',
        info: forwardMcOn ? motorInfo?.forwardStarboardMotor : null,
        overall: forwardMcOn ? subsystemInfo?.forwardStarboardMotor : null,
      ),
      MotorStatusRowData(
        name: 'AFT PORT\nMOTOR',
        info: aftMcOn ? motorInfo?.aftPortMotor : null,
        overall: aftMcOn ? subsystemInfo?.aftPortMotor : null,
      ),
      MotorStatusRowData(
        name: 'AFT\nSTARBOARD\nMOTOR',
        info: aftMcOn ? motorInfo?.aftStarboardMotor : null,
        overall: aftMcOn ? subsystemInfo?.aftStarboardMotor : null,
      ),
    ];
  }

  List<ControllerStatusRowData> get controllerRows {
    final forwardMcOn = powerInfo?.forwardMc == PowerStateEnum.on;
    final aftMcOn = powerInfo?.aftMc == PowerStateEnum.on;

    return [
      ControllerStatusRowData.fromInfo(
        name: 'FORWARD\nMOTOR CTRL',
        info: forwardMcOn ? mcInfo?.forwardMotorController : null,
        overall: forwardMcOn ? subsystemInfo?.forwardMotorController : null,
        power: powerInfo?.forwardMc,
      ),
      ControllerStatusRowData.fromInfo(
        name: 'AFT MOTOR\nCTRL',
        info: aftMcOn ? mcInfo?.aftMotorController : null,
        overall: aftMcOn ? subsystemInfo?.aftMotorController : null,
        power: powerInfo?.aftMc,
      ),
    ];
  }

  DriveState copyWith({
    DriveMotorInformationEntity? motorInfo,
    DriveMcInformationEntity? mcInfo,
    VcuSubsystemInfoEntity? subsystemInfo,
    VcuSubsystemPowerStateEntity? powerInfo,
  }) {
    return DriveState(
      motorInfo: motorInfo ?? this.motorInfo,
      mcInfo: mcInfo ?? this.mcInfo,
      subsystemInfo: subsystemInfo ?? this.subsystemInfo,
      powerInfo: powerInfo ?? this.powerInfo,
    );
  }
}

class MotorStatusRowData {
  final String name;
  final List<Color> colors;

  static const List<String> columns = [
    'FAULT\nSTATUS',
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
    'FAULT\nSTATUS',
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
    PowerStateEnum? power,
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

Color _getPowerStatusColor(PowerStateEnum? status) {
  if (status == null) return AppColors.unknown;
  switch (status) {
    case PowerStateEnum.on:
      return AppColors.healthy;
    case PowerStateEnum.off:
      return AppColors.faulty;
    case PowerStateEnum.unknown:
      return AppColors.unknown;
  }
}
