import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/compute_providers.dart';
import '../../application/compute_state.dart';

class ComputeScreen extends ConsumerWidget {
  const ComputeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(computeStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Computes (Flex 1)
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTile(state.tiles[0]),
                      SizedBox(height: 12.h),
                      _buildTile(state.tiles[1]),
                    ],
                  ),
                ),
              ),
            ),
            // Right Column: VCU (Flex 2)
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: _buildVcuTile(state.tiles[2]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(ComputeTileState state) {
    return Container(
      padding: EdgeInsets.all(10.w),
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
          ...state.items.map(_buildItem),
        ],
      ),
    );
  }

  Widget _buildVcuTile(ComputeTileState state) {
    // Group items by category (headers)
    final List<List<ComputeItem>> groups = [];
    List<ComputeItem> currentGroup = [];

    for (final item in state.items) {
      if (item.isHeader && currentGroup.isNotEmpty) {
        groups.add(currentGroup);
        currentGroup = [];
      }
      currentGroup.add(item);
    }
    if (currentGroup.isNotEmpty) {
      groups.add(currentGroup);
    }

    return Container(
      padding: EdgeInsets.all(10.w),
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
          Wrap(
            spacing: 24.w,
            runSpacing: 16.h,
            children: groups.map((group) {
              return SizedBox(
                width: 320.w, // Optimal width for a category column on 5" display
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: group.map(_buildItem).toList(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(ComputeItem item) {
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
    return Row(
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
    );
  }
}
