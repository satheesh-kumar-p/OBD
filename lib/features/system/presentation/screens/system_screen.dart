import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../system_providers.dart';
import '../state/system_screen_state.dart';

class SystemScreen extends ConsumerWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemScreenStateProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: _buildStageSection(state, 0),
          ),
          SizedBox(height: 4.h),
          Expanded(
            flex: state.stages.length > 1 && state.stages[1].items.length > 6 ? 2 : 1, 
            child: _buildStageSection(state, 1),
          ),
          SizedBox(height: 4.h),
          Expanded(
            flex: 1,
            child: _buildStageSection(state, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildStageSection(SystemScreenState state, int stageIndex) {
    if (stageIndex >= state.stages.length) return const SizedBox.shrink();
    final stage = state.stages[stageIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
          child: Text(
            stage.title.toUpperCase(),
            style: TextStyle(
              color: stage.titleColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final rowCount = (stage.items.length / 6).ceil();
              final itemWidth = (constraints.maxWidth - (5 * 4.w)) / 6;
              final itemHeight = (constraints.maxHeight - ((rowCount - 1) * 4.h)) / rowCount;
              final dynamicAspectRatio = itemWidth / itemHeight;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stage.items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: dynamicAspectRatio,
                  mainAxisSpacing: 4.h,
                  crossAxisSpacing: 4.w,
                ),
                itemBuilder: (context, index) {
                  final subsystem = stage.items[index];
                  final (color, statusText) = state.getVisuals(subsystem);

                  return _SubsystemTile(
                    name: state.getLabel(subsystem),
                    icon: state.getIcon(subsystem),
                    color: color,
                    statusText: statusText,
                    isStatusActive: state.isStatusActive(subsystem),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SubsystemTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String statusText;
  final bool isStatusActive;

  const _SubsystemTile({
    required this.name,
    required this.icon,
    required this.color,
    required this.statusText,
    required this.isStatusActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isStatusActive ? color.withOpacity(0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(
          color: isStatusActive ? color.withOpacity(0.4) : AppColors.border,
          width: 0.5.w,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Subsystem Name
              Text(
                name.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 4.h),
              // Subsystem Status
              Text(
                statusText.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isStatusActive ? color : AppColors.textSecondary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}