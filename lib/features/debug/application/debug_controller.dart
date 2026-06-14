import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/shared/vcu_estop_status/data/mapper/e_stop_info_mapper.dart';

import '../../../../core/comm/can_bus/can_frame.dart';
import '../../../../core/di/injection_container.dart';
import '../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../shared/comp_radio_state/data/mappers/comp_radio_state_mapper.dart';
import '../../dashboard/application/time_controller.dart';
import '../domain/entities/debug_message.dart';

// Import all mappers
import '../../../shared/comp_mode_status/data/mappers/mode_info_mapper.dart';
import '../../../shared/comp_time_sync/data/mappers/comp_time_sync_mapper.dart';
import '../../../shared/vcu_drive_health/data/mappers/drive_info_mapper.dart';
import '../../../shared/vcu_power_status/data/mappers/battery_info_mapper.dart';
import '../../../shared/vcu_subsystem_state/data/mapper/system_info_mapper.dart';
import '../../../shared/comp_global_time_info/data/mappers/global_time_info_mapper.dart';

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

class DebugController extends Notifier<DebugState> {
  final Map<int, CanExtractionStrategy> _mappers = {};
  static const int _maxLogsPerId = 200;

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
      CompRadioStateMapper(),
      EStopInfoMapper(),
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

    // Use the global time provider to get current time
    final syncTime = ref.read(timeControllerProvider);

    final newMessage = DebugMessage(
      timestamp: syncTime,
      id: frame.id,
      rawData: frame.data,
      decodedData: decoded,
    );

    // Update state: Append to end (latest at highest index)
    final currentLogs = List<DebugMessage>.from(state.messagesById[frame.id] ?? []);
    currentLogs.add(newMessage);

    if (currentLogs.length > _maxLogsPerId) {
      currentLogs.removeAt(0); // Prune oldest from the beginning
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

final debugControllerProvider = NotifierProvider<DebugController, DebugState>(DebugController.new);
