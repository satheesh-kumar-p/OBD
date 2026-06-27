import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/vcu_subsystem_power_state/data/vcu_subsystem_power_state_mapper.dart';
import '../domain/entities/debug_message.dart';
import '../../../../core/comm/can_bus/can_frame.dart';
import '../../../../core/di/injection_container.dart';
import '../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../core/constants/app_constants.dart';

// Import all mappers
import '../../../shared/vcu_status/data/vcu_status_mapper.dart';
import '../../../shared/sec_comp_hw_health/data/sec_compute_health_mapper.dart';
import '../../../shared/vcu_drive_motor_controller_health/data/mappers/drive_mc_info_mapper.dart';
import '../../../shared/vcu_drive_motor_health/data/mappers/drive_motor_info_mapper.dart';
import '../../../shared/vcu_power_status/data/mappers/battery_info_mapper.dart';
import '../../../shared/vcu_subsystem_state/data/mapper/vcu_subsystem_state_mapper.dart';
import '../../../shared/comp_subsystem_state/data/mappers/comp_subsystem_state_mapper.dart';

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

    final commManager = ref.watch(commManagerProvider);

    // Subscribe to every whitelisted message stream
    for (final id in AppConstants.whitelistedMessageIds) {
      final subscription = commManager.watchMessage(id).listen((frame) {
        if (frame != null) {
          addFrame(frame);
        }
      });

      // Ensure we clean up listeners when the controller is disposed
      ref.onDispose(() => subscription.cancel());
    }

    return DebugState(messagesById: {}, sortedIds: []);
  }

  void _registerMappers() {
    final List<CanExtractionStrategy> mappersList = [
      BatteryInfoMapper(),
      VcuSubsystemStateMapper(),
      CompSubsystemStateMapper(),
      VcuStatusMapper(),
      SecComputeHealthMapper(),
      DriveMcInfoMapper(),
      DriveMotorInfoMapper(),
      VcuSubsystemPowerStateMapper(),
      LvPduLoadCh1_4Mapper(),
      LvPduVcuLoadCh5_8Mapper(),
      VcuPduStatusMapper(),
      VcuPowerSubsystemHealthMapper(),
      VcuContactorStateMapper(),
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
    final syncTime = DateTime.now();

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

    List<int> newSortedIds = List<int>.from(state.sortedIds);
    if (!state.messagesById.containsKey(frame.id)) {
      newSortedIds.add(frame.id);
      newSortedIds.sort();
    }

    state = state.copyWith(
      messagesById: newMessagesById,
      sortedIds: newSortedIds,
    );
  }
}

final debugControllerProvider = NotifierProvider<DebugController, DebugState>(DebugController.new);
