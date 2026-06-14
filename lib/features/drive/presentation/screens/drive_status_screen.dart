import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../drive_providers.dart';
import '../../state/drive_state.dart';

class DriveScreen extends ConsumerWidget {
  const DriveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driveStateProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotorStatusTable(state.motorRows),
          _buildMotorControllerStatusTable(state.controllerRows),
        ],
      ),
    );
  }

  Widget _buildMotorStatusTable(List<MotorStatusRowData> rows) {
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
        ...rows.map((row) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
                  child: Text(row.name, style: rowHeaderStyle),
                ),
                ...row.colors.map((color) => _buildStatusDot(color)),
              ],
            )),
      ],
    );
  }

  Widget _buildMotorControllerStatusTable(List<ControllerStatusRowData> rows) {
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

    final columns = [
      'DRIVE',
      'OVER CURRENT',
      'OVER PRESSURE',
      'UNDER VOLTAGE',
      'OVER TEMP',
      'CAN COMM',
      'VOLT',
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
        ...rows.map((row) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
                  child: Text(row.name, style: rowHeaderStyle),
                ),
                ...row.colors.map((color) => _buildStatusDot(color)),
                Center(
                  child: Text(
                    row.voltage,
                    style: valueStyle,
                  ),
                ),
                Center(
                  child: Text(
                    row.temp,
                    style: valueStyle,
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildStatusDot(Color color) {
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
