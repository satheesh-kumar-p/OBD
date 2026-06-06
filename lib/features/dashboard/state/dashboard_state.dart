import 'dart:ui';
import 'package:scout_obd/shared/domain/entities/heartbeat_entity.dart';
import 'package:scout_obd/shared/domain/entities/link_status_entity.dart';
import 'package:scout_obd/shared/domain/entities/system_time_entity.dart';
import 'package:scout_obd/shared/domain/entities/time_sync_entity.dart';
import 'package:scout_obd/shared/domain/entities/ugv_mode_entity.dart';

import '../../../shared/enums/ugv_mode.dart';

enum HealthLevel { connected, noHeartbeat, disconnected }

class DashboardState {
  const DashboardState({
    this.linkStatus,
    this.heartbeat,
    this.timeSync,
    this.systemTime,
    this.mode,
    this.selectedIndex = 0,
  });

  final LinkStatusEntity? linkStatus;
  final HeartbeatEntity? heartbeat;
  final TimeSyncEntity? timeSync;
  final SystemTimeEntity? systemTime;
  final UgvModeEntity? mode;
  final int selectedIndex;

  DashboardState copyWith({
    LinkStatusEntity? linkStatus,
    HeartbeatEntity? heartbeat,
    TimeSyncEntity? timeSync,
    SystemTimeEntity? systemTime,
    UgvModeEntity? mode,
    int? selectedIndex,
  }) {
    return DashboardState(
      linkStatus: linkStatus ?? this.linkStatus,
      heartbeat: heartbeat ?? this.heartbeat,
      timeSync: timeSync ?? this.timeSync,
      systemTime: systemTime ?? this.systemTime,
      mode: mode ?? this.mode,
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
    final now = timeSync?.correctedNow ?? DateTime.now();
    return '${now.day.toString().padLeft(2,'0')}-'
        '${now.month.toString().padLeft(2,'0')}-'
        '${now.year} ${now.hour.toString().padLeft(2,'0')}:'
        '${now.minute.toString().padLeft(2,'0')}:'
        '${now.second.toString().padLeft(2,'0')}';
  }

  String get rttLabel => timeSync == null || timeSync!.isStale
      ? '--- ms'
      : '${timeSync!.roundTripMs} ms';

  String get modeName {
    final m = mode;
    if (m == null) return "NULL";
    return m.mainMode == UgvMainMode.modeA ? 'MODE A' : 'MODE B';
  }

  String get subModeName {
    final m = mode;
    if (m == null) return 'N/A';
    if (m.subMode == UgvSubMode.none) return 'NONE';
    if (m.subMode == UgvSubMode.hold) return 'HOLD';
    return 'UNKNOWN';
  }

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
