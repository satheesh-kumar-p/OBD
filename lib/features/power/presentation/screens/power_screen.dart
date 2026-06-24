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
                      _buildFaultRow(state.batteryFaults[i].name, state.batteryFaults[i].color),
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
                  // Top Section: HV PDU (Contactors)
                  _buildColumnContainer(
                    title: 'HV PDU',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < state.contactors.length; i++) ...[
                          _buildSimpleStatusRow(
                            state.contactors[i].name,
                            state.contactors[i].state,
                            state.contactors[i].color,
                          ),
                          if (i < state.contactors.length - 1)
                            Divider(color: Colors.white10, height: 1.h),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Bottom Section: LV Battery
                  _buildColumnContainer(
                    title: 'LV BATTERY',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < state.lvBatteryRows.length; i++) ...[
                          _buildLargeValueRow(
                            state.lvBatteryRows[i].label,
                            state.lvBatteryRows[i].value,
                          ),
                          if (i < state.lvBatteryRows.length - 1)
                            Divider(color: Colors.white10, height: 4.h),
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
              flex: 2, // Wider to accommodate table
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LV PDU Status
                  _buildColumnContainer(
                    title: 'LV PDU STATUS',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < state.pduChannels.length; i++) ...[
                          _buildPduStatusRow(state.pduChannels[i]),
                          if (i < state.pduChannels.length - 1)
                            Divider(color: Colors.white10, height: 1.h),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // LV PDU Health Table (Matching Drive Pattern)
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
    final double dotSize = size ?? 10.w;
    return Center(
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildFaultRow(String name, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name.toUpperCase(),
              style: TextStyle(
                color: Colors.white, 
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4.w),
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatusRow(String name, String state, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white, 
              fontSize: 16.sp, 
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            state,
            style: TextStyle(
              color: color, 
              fontSize: 16.sp, 
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeValueRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp, 
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white, 
              fontSize: 22.sp, 
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPduStatusRow(PduChannelDisplayData ch) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text(
            ch.name,
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 16.sp, 
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          Text(
            ch.statusText,
            style: TextStyle(
              color: ch.statusColor, 
              fontSize: 16.sp, 
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            ch.currentText,
            style: TextStyle(
              color: Colors.white, 
              fontSize: 18.sp, 
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
