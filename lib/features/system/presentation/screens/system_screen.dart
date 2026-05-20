import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../di/ugv_health_providers.dart';
import '../../domain/entities/health_status_entity.dart';
import '../../enums/subsystem_status_enum.dart';

class SystemScreen extends ConsumerWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthDataAsync = ref.watch(ugvHealthDataProvider);

    return healthDataAsync.when(
      data: (data) => _buildSubsystemTable(data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'ERROR: $err',
          style: TextStyle(
            color: Colors.red,
            fontSize: 32.sp,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildSubsystemTable(HealthStatusEntity data) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 36.sp,
      height: 1.5,
      fontFamily: 'monospace',
      fontWeight: FontWeight.w500,
    );
    final headerStyle = TextStyle(
      color: Colors.cyanAccent,
      fontSize: 36.sp,
      fontWeight: FontWeight.bold,
      height: 2.2,
      letterSpacing: 1.1,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 256.w,
        top: 80.h,
        right: 60.w,
        bottom: 60.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h, right: 60.w),
                    child: Text(
                      'SUB SYSTEM',
                      style: headerStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Center(
                      child: Text(
                        'STATUS',
                        style: headerStyle,
                      ),
                    ),
                  ),
                ],
              ),
              ...data.subsystemHealthMap.entries.map((entry) {
                final name = entry.key;
                final status = entry.value;

                Color dotColor;
                switch (status) {
                  case SubsystemStatus.healthy:
                    dotColor = Colors.green;
                    break;
                  case SubsystemStatus.unhealthy:
                    dotColor = Colors.red;
                    break;
                  case SubsystemStatus.noCommunication:
                    dotColor = Colors.white;
                    break;
                }

                return TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 60.w, bottom: 20.h),
                      child: Text(
                        name.toUpperCase(),
                        style: textStyle
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Center(
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: dotColor.withOpacity(0.4),
                                blurRadius: 6.w,
                                spreadRadius: 2.w,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
