import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../application/sensor_providers.dart';
import '../../application/sensor_state.dart';

class SensorScreen extends ConsumerWidget {
  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sensorStateProvider);

    return Container(
      color: const Color(0xFF0E1116),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate width for 3 columns including spacing
          final availableWidth = constraints.maxWidth - (16.w * 2); // 16.w is the padding
          final tileWidth = (availableWidth - (16.w * 2)) / 3; // 16.w is the horizontal spacing

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: state.tiles.map((tileState) {
                return SizedBox(
                  width: tileWidth,
                  child: _buildTile(tileState),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile(SensorTileState state) {
    return Container(
      padding: EdgeInsets.all(12.w),
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
            state.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Divider(color: Colors.white10, height: 16),
          ...state.items.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                  if (item.isText)
                    Text(
                      item.value ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: item.color,
                      ),
                    )
                  else
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.color,
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
