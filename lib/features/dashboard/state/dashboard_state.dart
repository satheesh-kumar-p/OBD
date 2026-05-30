import 'dart:ui';

import '../../../shared/domain/entities/heartbeat_entity.dart';
import '../../../shared/domain/entities/link_status_entity.dart';
import '../../../shared/domain/entities/system_time_entity.dart';
import '../../../shared/domain/entities/time_sync_entity.dart';
import '../../system/domain/entities/system_info_entity.dart';
import '../domain/entities/battery_info_entity.dart';
import '../domain/entities/mode_entity.dart';
import '../enums/mode_enum.dart';

enum HealthLevel { connected, noHeartbeat, disconnected }

class DashboardState {
  const DashboardState({
    this.linkStatus,
    this.heartbeat,
    this.timeSync,
    this.globalTime,
    this.systemTime,
    this.mode,
    this.battery,
    this.systemInfo,
    this.selectedIndex = 0,
  });

  final LinkStatusEntity? linkStatus;
  final HeartbeatEntity? heartbeat;
  final TimeSyncEntity? timeSync;
  final DateTime? globalTime;
  final SystemTimeEntity? systemTime;
  final ModeEntity? mode;
  final BatteryInfoEntity? battery;
  final SystemInfoEntity? systemInfo;
  final int selectedIndex;

  DashboardState copyWith({
    LinkStatusEntity? linkStatus,
    HeartbeatEntity? heartbeat,
    TimeSyncEntity? timeSync,
    DateTime? globalTime,
    SystemTimeEntity? systemTime,
    ModeEntity? mode,
    BatteryInfoEntity? battery,
    SystemInfoEntity? systemInfo,
    int? selectedIndex,
  }) {
    return DashboardState(
      linkStatus: linkStatus ?? this.linkStatus,
      heartbeat: heartbeat ?? this.heartbeat,
      timeSync: timeSync ?? this.timeSync,
      globalTime: globalTime ?? this.globalTime,
      systemTime: systemTime ?? this.systemTime,
      mode: mode ?? this.mode,
      battery: battery ?? this.battery,
      systemInfo: systemInfo ?? this.systemInfo,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  /// Pure transport connection status.
  bool get isSocketConnected => linkStatus?.isConnected ?? false;
  
  /// Pure application heartbeat status.
  bool get isVehicleAlive => heartbeat != null && !heartbeat!.isStale;

  /// Combined health logic.
  HealthLevel get healthLevel {
    if (!isSocketConnected) return HealthLevel.disconnected;
    if (!isVehicleAlive) return HealthLevel.noHeartbeat;
    return HealthLevel.connected;
  }

  String get linkLabel => switch (healthLevel) {
    HealthLevel.connected => 'CONNECTED',
    HealthLevel.noHeartbeat => 'NO HEARTBEAT',
    HealthLevel.disconnected => 'DISCONNECTED',
  };

  Color get linkColor => switch (healthLevel) {
    HealthLevel.connected => const Color(0xFF74FF9F),   // Green
    HealthLevel.noHeartbeat => const Color(0xFFFFB347), // Orange
    HealthLevel.disconnected => const Color(0xFFFF5C5C), // Red
  };

  String get systemTimeFormatted {
    // If we have synced CAN time, we use the repository's latest current time
    // instead of just the last emitted stream value. This ensures the clock
    // feels smooth even if the stream emission has slight jitter.
    final now = globalTime ?? timeSync?.correctedNow ?? DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  String get rttLabel => timeSync == null || timeSync!.isStale
      ? '--- ms'
      : '${timeSync!.roundTripMs} ms';

  String get modeName => mode?.mainMode.label ?? 'UNKNOWN';

  String get subModeName => mode?.subMode.label ?? 'N/A';

  String get uptimeFormatted {
    final bootSeconds = systemTime?.currentUpTimeSeconds;
    if (bootSeconds == null) return 'AWAITING';
    final hours = bootSeconds ~/ 3600;
    final minutes = (bootSeconds % 3600) ~/ 60;
    final seconds = bootSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  double get batteryLevel => 1.0;
}
