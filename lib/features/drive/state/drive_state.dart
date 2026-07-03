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

  bool get isLoading => driveInfo == null && mcTempVolt == null;

  List<MotorStatusRowData> get motorRows {
    return [
      MotorStatusRowData(name: 'FRONT LEFT MOTOR', info: driveInfo?.frontLeftMotor),
      MotorStatusRowData(name: 'FRONT RIGHT MOTOR', info: driveInfo?.frontRightMotor),
      MotorStatusRowData(name: 'REAR LEFT MOTOR', info: driveInfo?.rearLeftMotor),
      MotorStatusRowData(name: 'REAR RIGHT MOTOR', info: driveInfo?.rearRightMotor),
    ];
  }

  List<ControllerStatusRowData> get controllerRows {
    return [
      ControllerStatusRowData(
        name: 'FRONT MOTOR CTRL',
        info: driveInfo?.frontMotorController,
        voltage: mcTempVolt?.frontMcVoltage,
        temp: mcTempVolt?.frontMcTemp,
      ),
      ControllerStatusRowData(
        name: 'REAR MOTOR CTRL',
        info: driveInfo?.rearMotorController,
        voltage: mcTempVolt?.rearMcVoltage,
        temp: mcTempVolt?.rearMcTemp,
      ),
    ];
  }

  DriveState copyWith({
    DriveInformationEntity? driveInfo,
    bool clearDriveInfo = false,
    McTempVoltEntity? mcTempVolt,
    bool clearMcTempVolt = false,
  }) {
    return DriveState(
      driveInfo: clearDriveInfo ? null : (driveInfo ?? this.driveInfo),
      mcTempVolt: clearMcTempVolt ? null : (mcTempVolt ?? this.mcTempVolt),
    );
  }
}

class MotorStatusRowData {
  final String name;
  final List<Color> colors;

  MotorStatusRowData({
    required this.name,
    MotorInformation? info,
  }) : colors = [
          _getStatusColor(info?.overSpeed),
          _getStatusColor(info?.overload),
          _getStatusColor(info?.phaseLoss),
          _getStatusColor(info?.brake),
          _getStatusColor(info?.encoderFault),
          _getStatusColor(info?.overTemp),
          _getStatusColor(info?.hallFault),
          _getStatusColor(info?.stalled),
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
  })  : colors = [
          _getStatusColor(info?.drive),
          _getStatusColor(info?.overCurrent),
          _getStatusColor(info?.overPressure),
          _getStatusColor(info?.underVoltage),
          _getStatusColor(info?.overTemperature),
          _getStatusColor(info?.canCommunication),
        ],
        voltage = (voltage == null) ? '--' : '${voltage.toStringAsFixed(1)} V',
        temp = (temp == null) ? '--' : '$temp C';
}

Color _getStatusColor(Status? status) {
  if (status == null) return Colors.grey;
  return status == Status.healthy ? const Color(0xFF74FF9F) : Colors.red;
}
