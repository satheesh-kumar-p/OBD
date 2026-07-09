import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/sensor_providers.dart';
import '../../application/sensor_state.dart';

class SensorScreen extends ConsumerWidget {
  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sensorStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: _buildScrollableColumn(state.leftCol),
              ),
            ),
            // Middle Column
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: _buildScrollableColumn(state.middleCol),
              ),
            ),
            // Right Column
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: _buildScrollableColumn(state.rightCol),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableColumn(List<SensorTileState> tiles) {
    return ListView(
      padding: EdgeInsets.zero,
      children: tiles.map((tile) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildTile(tile),
        );
      }).toList(),
    );
  }

  Widget _buildTile(SensorTileState state) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            state.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          ...state.items.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (item.isText)
                    Text(
                      item.value ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    )
                  else
                    Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.color,
                        boxShadow: [
                          BoxShadow(
                            color: item.color.withOpacity(0.3),
                            blurRadius: 4.r,
                            spreadRadius: 1.r,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
