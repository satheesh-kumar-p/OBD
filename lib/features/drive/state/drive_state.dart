import 'package:flutter/material.dart';
import '../../../shared/vcu_drive_health/domain/entities/drive_information_entity.dart';
import '../../../shared/vcu_drive_health/domain/entities/motor_controller_information.dart';
import '../../../shared/vcu_drive_health/domain/entities/motor_information.dart';
import '../../../shared/vcu_drive_health/domain/entities/status.dart';
import '../../../shared/vcu_mc_temp_volt/domain/entities/mc_temp_volt_entity.dart';

class DriveState {
  final DriveInformationEntity? driveInfo;
  final McTempVoltEntity? mcTempVolt;

  const DriveState({
    this.driveInfo,
    this.mcTempVolt,
  });

  bool get isLoading => driveInfo == null;

  List<MotorStatusRowData> get motorRows {
    final frontStale = driveInfo != null && !driveInfo!.isFrontValid;
    final rearStale = driveInfo != null && !driveInfo!.isRearValid;

    return [
      MotorStatusRowData(name: 'FRONT LEFT MOTOR', info: driveInfo?.frontLeftMotor, isStale: frontStale),
      MotorStatusRowData(name: 'FRONT RIGHT MOTOR', info: driveInfo?.frontRightMotor, isStale: frontStale),
      MotorStatusRowData(name: 'REAR LEFT MOTOR', info: driveInfo?.rearLeftMotor, isStale: rearStale),
      MotorStatusRowData(name: 'REAR RIGHT MOTOR', info: driveInfo?.rearRightMotor, isStale: rearStale),
    ];
  }

  List<ControllerStatusRowData> get controllerRows {
    final frontStale = driveInfo != null && !driveInfo!.isFrontValid;
    final rearStale = driveInfo != null && !driveInfo!.isRearValid;

    return [
      ControllerStatusRowData(
        name: 'FRONT MOTOR CTRL',
        info: driveInfo?.frontMotorController,
        voltage: mcTempVolt?.frontMcVoltage,
        temp: mcTempVolt?.frontMcTemp,
        isStale: frontStale,
      ),
      ControllerStatusRowData(
        name: 'REAR MOTOR CTRL',
        info: driveInfo?.rearMotorController,
        voltage: mcTempVolt?.rearMcVoltage,
        temp: mcTempVolt?.rearMcTemp,
        isStale: rearStale,
      ),
    ];
  }

  DriveState copyWith({
    DriveInformationEntity? driveInfo,
    McTempVoltEntity? mcTempVolt,
  }) {
    return DriveState(
      driveInfo: driveInfo ?? this.driveInfo,
      mcTempVolt: mcTempVolt ?? this.mcTempVolt,
    );
  }
}

class MotorStatusRowData {
  final String name;
  final List<Color> colors;

  MotorStatusRowData({
    required this.name,
    MotorInformation? info,
    bool isStale = false,
  }) : colors = [
          _getStatusColor(isStale ? null : info?.overSpeed),
          _getStatusColor(isStale ? null : info?.overload),
          _getStatusColor(isStale ? null : info?.phaseLoss),
          _getStatusColor(isStale ? null : info?.brake),
          _getStatusColor(isStale ? null : info?.encoderFault),
          _getStatusColor(isStale ? null : info?.overTemp),
          _getStatusColor(isStale ? null : info?.hallFault),
          _getStatusColor(isStale ? null : info?.stalled),
        ];
}

class ControllerStatusRowData {
  final String name;
  final List<Color> colors;
  final String voltage;
  final String temp;

  ControllerStatusRowData({
    required this.name,
    MotorControllerInformation? info,
    double? voltage,
    int? temp,
    bool isStale = false,
  })  : colors = [
          _getStatusColor(isStale ? null : info?.drive),
          _getStatusColor(isStale ? null : info?.overCurrent),
          _getStatusColor(isStale ? null : info?.overPressure),
          _getStatusColor(isStale ? null : info?.underVoltage),
          _getStatusColor(isStale ? null : info?.overTemperature),
          _getStatusColor(isStale ? null : info?.canCommunication),
        ],
        voltage = (isStale || voltage == null) ? '--' : '${voltage.toStringAsFixed(1)} V',
        temp = (isStale || temp == null) ? '--' : '$temp C';
}

Color _getStatusColor(Status? status) {
  if (status == null) return Colors.grey;
  return status == Status.healthy ? const Color(0xFF74FF9F) : Colors.red;
}
