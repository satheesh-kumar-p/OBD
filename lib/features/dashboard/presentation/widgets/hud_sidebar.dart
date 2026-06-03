import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HudSidebar extends StatelessWidget {
  const HudSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.width,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          right: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemHeight = constraints.maxHeight / 6;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: items.length,
            itemBuilder: (context, i) {
              return SizedBox(
                height: itemHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.h,
                    horizontal: 8.w,
                  ),
                  child: _HudSidebarItem(
                    label: items[i],
                    selected: i == selectedIndex,
                    enabled: true,
                    onTap: () => onSelect(i),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HudSidebarItem extends StatelessWidget {
  const _HudSidebarItem({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  static const _cyan = Color(0xFF2FD0FF);
  static const _steel = Color(0xFF93A9B5);

  @override
  Widget build(BuildContext context) {
    final bg = selected ? _cyan.withOpacity(0.2) : Colors.transparent;
    final border = selected ? _cyan : Colors.transparent;
    final textColor = selected ? Colors.cyanAccent : _steel.withOpacity(0.7);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final radius = 10.r;

            return Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: border,
                  width: 2.5.w,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.sp,
                    letterSpacing: 0.5.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
