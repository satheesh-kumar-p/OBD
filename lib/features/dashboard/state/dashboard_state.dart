import 'package:flutter/material.dart';

import '../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../shared/comp_mode_status/domain/entities/mode_entity.dart';
import '../../../shared/comp_radio_state/domain/entities/comp_radio_state_entity.dart';
import '../../../shared/vcu_subsystem_state/domain/entities/system_info_entity.dart';
import '../../../shared/vcu_power_status/domain/entities/battery_info_entity.dart';
import '../../../shared/vcu_estop_status/domain/entities/e_stop_info_entity.dart';
import '../../../shared/vcu_estop_status/enums/e_stop_status_enum.dart';

enum HealthLevel { connected, noHeartbeat, disconnected }

class DashboardState {
  const DashboardState({
    this.globalTime,
    this.mode,
    this.battery,
    this.eStopInfo,
    this.systemInfo,
    this.compRadioInfo,
    this.selectedIndex = 0,
  });

  final DateTime? globalTime;
  final ModeEntity? mode;
  final BatteryInfoEntity? battery;
  final EStopInfoEntity? eStopInfo;
  final SystemInfoEntity? systemInfo;
  final CompRadioState? compRadioInfo;
  final int selectedIndex;

  DashboardState copyWith({
    DateTime? globalTime,
    ModeEntity? mode,
    BatteryInfoEntity? battery,
    EStopInfoEntity? eStopInfo,
    SystemInfoEntity? systemInfo,
    CompRadioState? compRadioInfo,
    int? selectedIndex,
  }) {
    return DashboardState(
      globalTime: globalTime ?? this.globalTime,
      mode: mode ?? this.mode,
      battery: battery ?? this.battery,
      eStopInfo: eStopInfo ?? this.eStopInfo,
      systemInfo: systemInfo ?? this.systemInfo,
      compRadioInfo: compRadioInfo ?? this.compRadioInfo,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  String get systemTimeFormatted {
    // If we have synced CAN time, we use the repository's latest current time
    // instead of just the last emitted stream value. This ensures the clock
    // feels smooth even if the stream emission has slight jitter.
    final now = globalTime ?? DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  String get modeName => mode?.mainMode.label ?? 'UNKNOWN';

  String get subModeName => mode?.holdSubMode.label ?? 'N/A';

  String get driveModeName => mode?.driveMode.label ?? 'UNKNOWN';

  String get speedModeName => mode?.speedMode.label ?? 'UNKNOWN';

  // --- UI Transformation Get Getters ---

  Color get hvBatteryColor {
    final soc = battery?.hvBatterySoc ?? 0;
    if (soc < 20) return const Color(0xFFFF3B3B);
    if (soc < 50) return Colors.orangeAccent;
    return const Color(0xFF00FF66);
  }

  Color get lvBatteryColor {
    final soc = battery?.lvBatterySoc ?? 0;
    if (soc < 20) return const Color(0xFFFF3B3B);
    if (soc < 50) return Colors.orangeAccent;
    return const Color(0xFF00FF66);
  }

  Color get eStopColor {
    return switch (eStopInfo?.status) {
      EStopStatus.engaged => const Color(0xFFFF3B3B),
      EStopStatus.released => const Color(0xFF00FF66),
      EStopStatus.unknown || null => Colors.white12,
    };
  }

  Color get handCtrlColor {
    final status = compRadioInfo?.uhfRadio;
    return switch (status) {
      SubsystemFaultState.noFault => const Color(0xFF00FF66),
      SubsystemFaultState.faulty => const Color(0xFFFF3B3B),
      SubsystemFaultState.unknown => Colors.white,
      SubsystemFaultState.badValue || null => Colors.orange,
    };
  }

  Color get headlightsColor => (mode?.headlightsOn ?? false) ? Colors.orangeAccent : Colors.white10;

  Color get fogLightsColor => (mode?.frontFogLightsOn ?? false) ? Colors.orangeAccent : Colors.white10;

  double get batteryLevel => 1.0;
}
