import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import 'communication_provider.dart';
import 'communication_state.dart';

class CommunicationScreen extends ConsumerWidget {
  const CommunicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communicationStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: _buildTile(state.uhfRadioTile),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: _buildTile(state.lbandRadioTile),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(CommunicationTileState state) {
    // Group items by category (headers)
    final List<List<CommunicationItem>> groups = [];
    List<CommunicationItem> currentGroup = [];

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

    final contentPadding = 12.w;
    final spacing = 24.w;

    return Container(
      padding: EdgeInsets.all(contentPadding),
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
          SizedBox(height: 12.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnWidth = (constraints.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: 16.h,
                children: groups.map((group) {
                  return SizedBox(
                    width: columnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: group.map(_buildItem).toList(),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(CommunicationItem item) {
    final labelStyle = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 16.sp,
    );

    if (item.isHeader) {
      return Padding(
        padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
        child: Text(
          item.label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.accentVariant,
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item.label,
              style: labelStyle,
            ),
          ),
          SizedBox(width: 8.w),
          if (item.isText)
            Text(
              item.value ?? '',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: item.color,
              ),
            )
          else
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.color,
                boxShadow: [
                  BoxShadow(
                    color: item.color!.withOpacity(0.3),
                    blurRadius: 4.r,
                    spreadRadius: 1.r,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
