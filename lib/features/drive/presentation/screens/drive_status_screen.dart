import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../di/drive_info_providers.dart';
import '../../domain/entities/drive_information_entity.dart';
import '../../domain/entities/status.dart';

class DriveScreen extends ConsumerWidget {
  const DriveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveDataAsync = ref.watch(driveInfoProvider);

    return driveDataAsync.when(
      data: (data) => _buildBody(data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'ERROR: $err',
          style: TextStyle(
            color: Colors.red,
            fontSize: 32.sp,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildBody(DriveInformationEntity data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        left: 256.w,
        top: 80.h,
        right: 60.w,
        bottom: 60.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotorStatusWidget(data),
          SizedBox(height: 40.h),
          _buildMotorControllerStatusWidget(data),
        ],
      ),
    );
  }

  Widget _buildMotorStatusWidget(DriveInformationEntity data) {
    final headerStyle = TextStyle(
      color: Colors.cyanAccent,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );
    final rowHeaderStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    final motors = {
      'FRONT LEFT MOTOR': data.frontLeftMotor,
      'FRONT RIGHT MOTOR': data.frontRightMotor,
      'REAR LEFT MOTOR': data.rearLeftMotor,
      'REAR RIGHT MOTOR': data.rearRightMotor,
    };

    final columns = [
      'OVER SPEED',
      'OVER LOAD',
      'PHASE LOSS',
      'BRAKE',
      'ENCODER FAULT',
      'OVER TEMP',
      'HALL FAULT',
      'STALL'
    ];

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
      },
      children: [
        // Header Row
        TableRow(
          children: [
            const SizedBox.shrink(),
            ...columns.map((col) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                  child: Text(col, style: headerStyle, textAlign: TextAlign.center),
                )),
          ],
        ),
        // Data Rows
        ...motors.entries.map((entry) {
          final motor = entry.value;
          return TableRow(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
                child: Text(entry.key, style: rowHeaderStyle),
              ),
              _buildStatusDot(motor.overSpeed),
              _buildStatusDot(motor.overload),
              _buildStatusDot(motor.phaseLoss),
              _buildStatusDot(motor.brake),
              _buildStatusDot(motor.encoderFault),
              _buildStatusDot(motor.overTemp),
              _buildStatusDot(motor.hallFault),
              _buildStatusDot(motor.stalled),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildMotorControllerStatusWidget(DriveInformationEntity data) {
    final headerStyle = TextStyle(
      color: Colors.cyanAccent,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );
    final rowHeaderStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );
    final valueStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
      fontFamily: 'monospace',
    );

    final controllers = {
      'LEFT MOTOR CTRL': data.leftMotorController,
      'RIGHT MOTOR CTRL': data.rightMotorController,
    };

    final columns = [
      'DRIVE',
      'OVER CURRENT',
      'OVER PRESSURE',
      'UNDER VOLTAGE',
      'OVER TEMP',
      'CAN COMM',
      'BATT VOLT',
      'TEMP'
    ];

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
      },
      children: [
        // Header Row
        TableRow(
          children: [
            const SizedBox.shrink(),
            ...columns.map((col) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                  child: Text(col, style: headerStyle, textAlign: TextAlign.center),
                )),
          ],
        ),
        // Data Rows
        ...controllers.entries.map((entry) {
          final ctrl = entry.value;
          return TableRow(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
                child: Text(entry.key, style: rowHeaderStyle),
              ),
              _buildStatusDot(ctrl.drive),
              _buildStatusDot(ctrl.overCurrent),
              _buildStatusDot(ctrl.underPressure),
              _buildStatusDot(ctrl.underVoltage),
              _buildStatusDot(ctrl.overTemperature),
              _buildStatusDot(ctrl.canCommunication),
              // TODO: MAVLINK
              // Center(child: Text('${ctrl.voltage} V', style: valueStyle)),
              // Center(child: Text('${ctrl.temperature} C', style: valueStyle)),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStatusDot(Status status) {
    final color = status == Status.healthy ? const Color(0xFF74FF9F) : Colors.red;
    return Center(
      child: Container(
        width: 16.w,
        height: 16.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6.w,
              spreadRadius: 2.w,
            )
          ],
        ),
      ),
    );
  }
}
