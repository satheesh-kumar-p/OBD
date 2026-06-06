import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../di/debug_providers.dart';
import '../../domain/entities/debug_message.dart';

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  int _currentIdCount = 0;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabController(int newCount) {
    if (_currentIdCount != newCount) {
      final oldIndex = _tabController?.index ?? 0;
      _tabController?.dispose();
      _tabController = TabController(
        length: newCount,
        vsync: this,
        initialIndex: (oldIndex < newCount) ? oldIndex : 0,
      );
      _currentIdCount = newCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final debugState = ref.watch(debugNotifierProvider);
    
    if (debugState.sortedIds.isEmpty) {
      return const Center(
        child: Text(
          'AWAITING CAN TRAFFIC...',
          style: TextStyle(
            color: Colors.white24,
            fontSize: 24,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    _handleTabController(debugState.sortedIds.length);
    final controller = _tabController!;

    return Column(
      children: [
        // Tab Bar
        Container(
          height: 60.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(bottom: BorderSide(color: Colors.white10)),
          ),
          child: TabBar(
            controller: controller,
            isScrollable: true,
            indicatorColor: Colors.cyanAccent,
            labelColor: Colors.cyanAccent,
            unselectedLabelColor: Colors.white60,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
            tabs: debugState.sortedIds.map((id) => Tab(
              text: '0x${id.toRadixString(16).toUpperCase()}',
            )).toList(),
          ),
        ),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: controller,
            children: debugState.sortedIds.map((id) {
              final messages = debugState.messagesById[id] ?? [];
              return _DebugLogList(messages: messages);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DebugLogList extends StatefulWidget {
  final List<DebugMessage> messages;

  const _DebugLogList({required this.messages});

  @override
  State<_DebugLogList> createState() => _DebugLogListState();
}

class _DebugLogListState extends State<_DebugLogList> {
  final ScrollController _scrollController = ScrollController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // On the very first build of a specific tab, we jump to the top (max extent)
    // to show the latest messages.
    if (!_initialized && widget.messages.isNotEmpty) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      reverse: true, // index 0 (oldest) at bottom, anchor point.
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final msg = widget.messages[index];
        final bool isDecoded = msg.decodedData != null;

        return Container(
          key: ValueKey('${msg.id}_${msg.timestamp.microsecondsSinceEpoch}'),
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: isDecoded ? Colors.cyanAccent.withOpacity(0.2) : Colors.white24,
              width: 1.5.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timestamp in []
              Text(
                '[ ${_formatTime(msg.timestamp)} ]',
                style: TextStyle(
                  color: Colors.cyanAccent.withOpacity(0.8),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8.h),
              // Main Data
              Text(
                isDecoded ? msg.decodedData! : 'RAW: ${msg.rawDataHex}',
                style: TextStyle(
                  color: isDecoded ? Colors.white : Colors.white70,
                  fontSize: 18.sp,
                  fontFamily: 'monospace',
                  fontWeight: isDecoded ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              // Hex Detail
              if (isDecoded) ...[
                SizedBox(height: 8.h),
                Text(
                  'HEX: ${msg.rawDataHex}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    final date = '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}.${dt.millisecond.toString().padLeft(3, '0')}';
    return '$date $time';
  }
}
