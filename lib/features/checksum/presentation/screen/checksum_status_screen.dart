import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:scout_obd/core/theme/app_colors.dart';
import 'package:scout_obd/features/checksum/domain/entities/checksum_status_entity.dart';
import 'package:scout_obd/features/checksum/presentation/checksum_providers.dart';

class ChecksumStatusScreen extends ConsumerWidget {
  const ChecksumStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(checksumStatusUiStateProvider).asData?.value ?? const [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                child: Text(
                  'SYSTEM CHECKSUMS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Text(
                          'Waiting for checksum packets…',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
                        ),
                      )
                    : ListView.separated(
                        itemCount: entries.length,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, __) => SizedBox(height: 6.h),
                        itemBuilder: (context, index) => _AppStatusCard(entity: entries[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppStatusCard extends StatelessWidget {
  final ChecksumStatusEntity entity;

  const _AppStatusCard({required this.entity});

  @override
  Widget build(BuildContext context) {
    final statusColor = entity.hasUnknownChecksum ? AppColors.warning : AppColors.healthy;

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: statusColor.withOpacity(0.35), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  entity.appName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  entity.version,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CHECKSUM (SHA256):',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.6),
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  entity.checksum,
                  softWrap: true,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 30.sp,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}