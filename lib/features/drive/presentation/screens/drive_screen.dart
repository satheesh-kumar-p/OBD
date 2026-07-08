import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
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
        horizontal: 10.w,
        vertical: 10.h,
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
      color: AppColors.accentVariant,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );
    final rowHeaderStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    final columns = MotorStatusRowData.columns;

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
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                  child: Text(col, style: headerStyle, textAlign: TextAlign.center),
                )),
          ],
        ),
        // Data Rows
        ...rows.map((row) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 6.w, top: 6.h, bottom: 6.h),
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
      color: AppColors.accentVariant,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );
    final rowHeaderStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    final columns = ControllerStatusRowData.columns;

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
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                  child: Text(col, style: headerStyle, textAlign: TextAlign.center),
                )),
          ],
        ),
        // Data Rows
        ...rows.map((row) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 6.w, top: 6.h, bottom: 6.h),
                  child: Text(row.name, style: rowHeaderStyle),
                ),
                ...row.colors.map((color) => _buildStatusDot(color)),
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
