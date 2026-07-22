import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../power_providers.dart';
import '../../state/power_state.dart';

class PowerScreen extends ConsumerWidget {
  const PowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(powerStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Scrollable
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTile('HV PDU', state.hvPduItems),
                      SizedBox(height: 12.h),
                      _buildTile('DC-DC (48-12 V)', state.dcDcItems),
                      SizedBox(height: 12.h),
                      _buildTile('Lights', state.lightItems),
                    ],
                  ),
                ),
              ),
            ),

            // Middle Column - Scrollable
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: _buildTile('HV Battery', state.hvBatteryItems),
                ),
              ),
            ),

            // Right Column - Scrollable
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTile('LV PDU', state.lvPduItems),
                      SizedBox(height: 12.h),
                      _buildTile('LV Battery', state.lvBatteryItems),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, List<PowerItem> items) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          ...items.map((item) {
            if (item.isHeader) {
              return Text(
                item.label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentVariant,
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
