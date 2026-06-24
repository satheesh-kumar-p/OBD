import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../power_providers.dart';
import '../../state/power_state.dart';

class PowerScreen extends ConsumerWidget {
  const PowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(powerStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: HV Battery (BMS)
            Expanded(
              flex: 1,
              child: _buildColumnContainer(
                title: 'HV BATTERY (BMS)',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < state.batteryFaults.length; i++) ...[
                      _buildStatusRow(
                        label: state.batteryFaults[i].name,
                        dotColor: state.batteryFaults[i].color,
                      ),
                      if (i < state.batteryFaults.length - 1)
                        Divider(color: Colors.white10, height: 1.h),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(width: 4.w),

            // Middle Column: HV PDU & LV Battery
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildColumnContainer(
                    title: 'HV PDU',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < state.contactors.length; i++) ...[
                          _buildStatusRow(
                            label: state.contactors[i].name,
                            value: state.contactors[i].state,
                            valueColor: state.contactors[i].color,
                          ),
                          if (i < state.contactors.length - 1)
                            Divider(color: Colors.white10, height: 1.h),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildColumnContainer(
                    title: 'LV BATTERY',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < state.lvBatteryRows.length; i++) ...[
                          _buildStatusRow(
                            label: state.lvBatteryRows[i].label,
                            value: state.lvBatteryRows[i].value,
                          ),
                          if (i < state.lvBatteryRows.length - 1)
                            Divider(color: Colors.white10, height: 1.h),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),

            // Right Column: LV PDU (Status & Health)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildColumnContainer(
                    title: 'LV PDU STATUS',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < state.pduChannels.length; i++) ...[
                          _buildStatusRow(
                            label: state.pduChannels[i].name,
                            value: state.pduChannels[i].statusText,
                            valueColor: state.pduChannels[i].statusColor,
                            trailingValue: state.pduChannels[i].currentText,
                          ),
                          if (i < state.pduChannels.length - 1)
                            Divider(color: Colors.white10, height: 1.h),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildColumnContainer(
                    title: 'LV PDU HEALTH',
                    child: _buildPduHealthTable(state.pduChannels),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnContainer({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(2.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          Divider(color: Colors.white24, thickness: 1.h, height: 4.h),
          child,
        ],
      ),
    );
  }

  Widget _buildPduHealthTable(List<PduChannelDisplayData> channels) {
    final headerStyle = TextStyle(
      color: Colors.cyanAccent,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );
    final rowHeaderStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    final columns = ['SHORT CIRCUIT', 'CURRENT LIMIT', 'OPEN CIRCUIT'];

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
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                  child: Text(col, style: headerStyle, textAlign: TextAlign.center),
                )),
          ],
        ),
        // Data Rows
        ...channels.map((ch) => TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(ch.name, style: rowHeaderStyle),
                ),
                ...ch.healthColors.map((color) => _buildStatusDot(color, size: 14.w)),
              ],
            )),
      ],
    );
  }

  Widget _buildStatusDot(Color color, {double? size}) {
    final double dotSize = size ?? 12.w;
    return Center(
      child: Container(
        width: dotSize,
        height: dotSize,
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

  Widget _buildStatusRow({
    required String label,
    String? value,
    Color? valueColor,
    Color? dotColor,
    String? trailingValue,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (value != null)
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          if (trailingValue != null) ...[
            SizedBox(width: 8.w),
            Text(
              trailingValue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ],
          if (dotColor != null) ...[
            SizedBox(width: 12.w),
            SizedBox(
              width: 12.w,
              height: 12.w,
              child: _buildStatusDot(dotColor),
            ),
          ],
        ],
      ),
    );
  }
}
