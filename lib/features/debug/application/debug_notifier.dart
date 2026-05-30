import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/comm/can_bus/can_frame.dart';
import '../../../../shared/data/can_field.dart';
import '../../dashboard/di/dashboard_providers.dart';
import '../domain/entities/debug_message.dart';
import '../../../shared/di/global_time_info_providers.dart';

// Import all mappers
import '../../dashboard/data/mappers/battery_info_mapper.dart';
import '../../system/data/mappers/system_info_mapper.dart';
import '../../drive/data/mappers/drive_info_mapper.dart';
import '../../dashboard/data/mappers/mode_info_mapper.dart';
import '../../../shared/data/mappers/global_time_info_mapper.dart';
import '../../../shared/data/mappers/comp_time_sync_mapper.dart';
import '../../system/data/mappers/compute_comm_info_mapper.dart';

class DebugState {
  final Map<int, List<DebugMessage>> messagesById;
  final List<int> sortedIds;

  DebugState({
    required this.messagesById,
    required this.sortedIds,
  });

  DebugState copyWith({
    Map<int, List<DebugMessage>>? messagesById,
    List<int>? sortedIds,
  }) {
    return DebugState(
      messagesById: messagesById ?? this.messagesById,
      sortedIds: sortedIds ?? this.sortedIds,
    );
  }
}

class DebugNotifier extends Notifier<DebugState> {
  final Map<int, CanExtractionStrategy> _mappers = {};
  static const int _maxLogsPerId = 50;

  @override
  DebugState build() {
    _registerMappers();

    // Listen to CAN frame stream
    ref.listen(canFrameStreamProvider, (previous, next) {
      final frame = next.asData?.value;
      if (frame != null) {
        addFrame(frame);
      }
    });

    return DebugState(messagesById: {}, sortedIds: []);
  }

  void _registerMappers() {
    final List<CanExtractionStrategy> mappersList = [
      BatteryInfoMapper(),
      SystemInfoMapper(),
      DriveInfoMapper(),
      ModeInfoMapper(),
      GlobalTimeInfoMapper(),
      CompTimeSyncMapper(),
      ComputeCommInfoMapper(),
    ];

    for (final strategy in mappersList) {
      _mappers[strategy.messageId] = strategy;
    }
  }

  void addFrame(CanFrame frame) {
    final strategy = _mappers[frame.id];
    String? decoded;

    if (strategy != null) {
      try {
        final entity = strategy.parse(frame.data);
        decoded = entity.toString();
      } catch (e) {
        decoded = 'DECODE ERROR: $e';
      }
    }

    final syncTime = ref.read(globalTimeRepositoryProvider).currentTime;

    final newMessage = DebugMessage(
      timestamp: syncTime,
      id: frame.id,
      rawData: frame.data,
      decodedData: decoded,
    );

    // Update state
    final currentLogs = List<DebugMessage>.from(state.messagesById[frame.id] ?? []);
    currentLogs.insert(0, newMessage);

    if (currentLogs.length > _maxLogsPerId) {
      currentLogs.removeLast();
    }

    final newMessagesById = Map<int, List<DebugMessage>>.from(state.messagesById);
    newMessagesById[frame.id] = currentLogs;

    List<int> newSortedIds = state.sortedIds;
    if (!state.messagesById.containsKey(frame.id)) {
      newSortedIds = List<int>.from(state.sortedIds)..add(frame.id);
      newSortedIds.sort();
    }

    state = state.copyWith(
      messagesById: newMessagesById,
      sortedIds: newSortedIds,
    );
  }
}
