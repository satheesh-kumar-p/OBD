import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../system_providers.dart';

class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StageSection(index: 0),
          SizedBox(height: 16.h),
          const _StageSection(index: 1),
          SizedBox(height: 16.h),
          const _StageSection(index: 2),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _StageSection extends ConsumerWidget {
  final int index;
  const _StageSection({required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = ref.watch(systemScreenStateProvider.select((s) => s.stages[index]));
    final state = ref.watch(systemScreenStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 4.h, top: 4.h),
          child: Text(
            stage.title,
            style: TextStyle(
              color: stage.titleColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stage.items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1.45,
            mainAxisSpacing: 6.h,
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
        color: isStatusActive ? color.withOpacity(0.1) : Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(
          color: isStatusActive ? color.withOpacity(0.4) : Colors.white10,
          width: 0.5.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 2.r, right: 2.r, bottom: 2.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42.r,
              color: isStatusActive ? color : Colors.white38,
            ),
            SizedBox(height: 2.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                statusText.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
