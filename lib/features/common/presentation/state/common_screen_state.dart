import 'package:flutter/material.dart';
import '../../../../core/enums/subsystem_fault_state_enum.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/comp_subsystem_state/domain/entities/comp_subsystem_state_entity.dart';
import '../../../../shared/vcu_power_status/domain/entities/battery_info_entity.dart';
import '../../../../shared/vcu_status/domain/vcu_status_entity.dart';
import '../../../../shared/vcu_status/domain/vcu_status_enums.dart';

class ArmStatusState {
  final String label;
  final Color color;
  final Color bgColor;
  final IconData? icon;

  const ArmStatusState({
    required this.label,
    required this.color,
    required this.bgColor,
    this.icon,
  });
}

class SafetyIndicatorState {
  final String label;
  final Color color;
  final IconData icon;

  const SafetyIndicatorState({
    required this.label,
    required this.color,
    required this.icon,
  });
}

class BatteryIndicatorState {
  final int soc;
  final Color color;
  final bool isCharging;
  final String label;

  const BatteryIndicatorState({
    required this.soc,
    required this.color,
    required this.isCharging,
    required this.label,
  });
}

class CommonScreenState {
  final VcuStatusEntity? vcuStatus;
  final CompSubsystemStateEntity? computeCommInfo;
  final BatteryInfoEntity? batteryInfo;
  final String systemTime;

  const CommonScreenState({
    this.vcuStatus,
    this.computeCommInfo,
    this.batteryInfo,
    this.systemTime = '',
  });

  // --- Arm Status ---
  ArmStatusState get armStatus {
    final armMode = vcuStatus?.armMode ?? ArmModeEnum.unknown;
    final (color, bgColor, IconData? icon) = switch (armMode) {
      ArmModeEnum.armed => (
        AppColors.danger,
        AppColors.danger.withOpacity(0.1),
        Icons.lock_open_rounded
      ),
      ArmModeEnum.disarmed => (
        AppColors.success,
        AppColors.success.withOpacity(0.1),
        Icons.lock_rounded
      ),
      ArmModeEnum.override => (
        AppColors.warning,
        AppColors.warning.withOpacity(0.1),
        Icons.warning_amber_rounded
      ),
      _ => (
        AppColors.textDisabled,
        AppColors.surface,
        null,
      ),
    };

    return ArmStatusState(
      label: armMode.label,
      color: color,
      bgColor: bgColor,
      icon: icon,
    );
  }

  // --- GCS Status ---
  Color get gcsStatusColor {
    final status = computeCommInfo?.lBandRadio;
    return switch (status) {
      SubsystemFaultState.healthy => AppColors.healthy,
      SubsystemFaultState.faulty => AppColors.faulty,
      SubsystemFaultState.unknown || null => AppColors.textPrimary,
    };
  }

  // --- Hand Controller Status ---
  Color get handCtrlStatusColor {
    final status = computeCommInfo?.uhfRadio;
    return switch (status) {
      SubsystemFaultState.healthy => AppColors.healthy,
      SubsystemFaultState.faulty => AppColors.faulty,
      SubsystemFaultState.unknown || null => AppColors.textPrimary,
    };
  }

  // --- Safety Status ---
  List<SafetyIndicatorState> get safetyIndicators {
    return [
      SafetyIndicatorState(
        label: 'E-STOP',
        color: _getEmergencyColor(vcuStatus?.emergency),
        icon: Icons.stop_circle_rounded,
      ),
      SafetyIndicatorState(
        label: 'REMOTE\nE-STOP',
        color: _getEmergencyColor(vcuStatus?.remoteEmergency),
        icon: Icons.settings_remote_rounded,
      ),
      SafetyIndicatorState(
        label: 'TOW',
        color: _getTowColor(vcuStatus?.towMode),
        icon: Icons.car_crash_outlined,
      ),
    ];
  }

  Color _getEmergencyColor(EmergencyEnum? state) {
    return switch (state) {
      EmergencyEnum.disengaged => AppColors.success,
      EmergencyEnum.engaged => AppColors.danger,
      _ => AppColors.textDisabled,
    };
  }

  Color _getTowColor(TowModeEnum? state) {
    return switch (state) {
      TowModeEnum.disengaged => AppColors.success,
      TowModeEnum.engaged => AppColors.danger,
      _ => AppColors.textDisabled,
    };
  }

  // --- Drive Mode ---
  (String, String, Color) get driveModeVisuals {
    final driveMode = vcuStatus?.driveMode ?? DriveModeEnum.unknown;
    final driveLimit = vcuStatus?.driveModeLimit ?? DriveModeLimitEnum.unknown;

    return (
      driveMode.label,
      driveLimit.label,
      driveLimit == DriveModeLimitEnum.unknown ? AppColors.textPrimary : AppColors.warning,
    );
  }

  // --- Mission Mode ---
  (String, String, Color) get missionModeVisuals {
    final autonomyMode = vcuStatus?.autonomyMode ?? AutonomyModeEnum.unknown;
    final holdState = vcuStatus?.holdState ?? HoldStateEnum.unknown;

    final subColor = switch (holdState) {
      HoldStateEnum.disengaged => AppColors.success,
      HoldStateEnum.engaged => AppColors.danger,
      HoldStateEnum.unknown => AppColors.textPrimary,
    };

    return (
      autonomyMode.label,
      'HOLD: ${holdState.label}',
      subColor,
    );
  }

  // --- Battery Status ---
  BatteryIndicatorState get lvBattery {
    final soc = batteryInfo?.lvBatterySoc ?? 0;
    return BatteryIndicatorState(
      soc: soc,
      color: _getBatteryColor(soc),
      isCharging: false,
      label: 'LV',
    );
  }

  BatteryIndicatorState get hvBattery {
    final soc = batteryInfo?.hvBatterySoc ?? 0;
    final isCharging = vcuStatus?.chargingInProgress ?? false;
    return BatteryIndicatorState(
      soc: soc,
      color: _getBatteryColor(soc),
      isCharging: isCharging,
      label: 'HV',
    );
  }

  Color _getBatteryColor(int soc) {
    if (soc < 20) return AppColors.danger;
    if (soc < 50) return AppColors.warning;
    return AppColors.success;
  }
}
