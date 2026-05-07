import 'dart:ui';
import 'package:scout_obd/shared/domain/entities/heartbeat_entity.dart';
import 'package:scout_obd/shared/domain/entities/link_status_entity.dart';
import 'package:scout_obd/shared/domain/entities/time_sync_entity.dart';

enum HealthLevel { connected, noHeartbeat, disconnected }

class DashboardState {
  const DashboardState({
    this.linkStatus,
    this.heartbeat,
    this.timeSync,
    this.selectedIndex = 0,
  });

  final LinkStatusEntity? linkStatus;
  final HeartbeatEntity? heartbeat;
  final TimeSyncEntity? timeSync;
  final int selectedIndex;

  DashboardState copyWith({
    LinkStatusEntity? linkStatus,
    HeartbeatEntity? heartbeat,
    TimeSyncEntity? timeSync,
    int? selectedIndex,
  }) {
    return DashboardState(
      linkStatus: linkStatus ?? this.linkStatus,
      heartbeat: heartbeat ?? this.heartbeat,
      timeSync: timeSync ?? this.timeSync,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  /// Pure transport connection status.
  bool get isSocketConnected => linkStatus?.isConnected ?? false;
  
  /// Pure application heartheat status.
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
    if (heartbeat == null) return 'UNKNOWN';
    switch (heartbeat!.customMode) {
      case 0:
        return 'MODE A';
      case 1:
        return "MODE B";
      default:
        return "UNKNOWN";
    }
  }

  String get uptimeFormatted {
    return '00:00:00';
  }

  double get batteryLevel => 1.0;
}
