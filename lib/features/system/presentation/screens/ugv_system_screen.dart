import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/ugv_system_entity.dart';
import '../../../../shared/enums/ugv_sub_system.dart';
import '../../di/ugv_health_providers.dart';

class UgvSystemScreen extends ConsumerWidget {
  const UgvSystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthDataAsync = ref.watch(ugvHealthDataProvider(AppConstants.primaryLinkId));
    
    return healthDataAsync.when(
      data: (data) => _buildSubsystemTable(data),
      loading: () => Center(
        child: Text(
          'LOADING...', 
          style: TextStyle(
            color: Colors.white24, 
            fontSize: 32.sp,
            fontFamily: 'monospace',
          ),
        ),
      ),
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

  Widget _buildSubsystemTable(UgvSystemEntity data) {
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
              ...UgvSubsystem.values.map((sub) {
                final isPresent = data.subsystems.present.contains(sub);
                final isHealthy = data.subsystems.healthy.contains(sub);

                Color dotColor;
                if (!isPresent) {
                  dotColor = Colors.white;
                } else if (isHealthy) {
                  dotColor = Colors.green; // Green
                } else {
                  dotColor = Colors.red;
                }

                return TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 60.w, bottom: 20.h),
                      child: Text(
                        sub.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').toUpperCase(),
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
