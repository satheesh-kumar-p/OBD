import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/vcu_contactor_state/di/contactor_state_providers.dart';
import '../../shared/vcu_pdu_status/di/vcu_pdu_status_providers.dart';
import '../../shared/vcu_power_subsystem_health/di/power_subsystem_health_providers.dart';
import '../../shared/vcu_power_status/di/battery_info_providers.dart';
import 'state/power_state.dart';

final powerStateProvider = NotifierProvider<PowerStateNotifier, PowerState>(() {
  return PowerStateNotifier();
});

class PowerStateNotifier extends Notifier<PowerState> {
  DateTime? _lastContactorUpdate;
  DateTime? _lastPduStatusUpdate;
  DateTime? _lastBatteryHealthUpdate;
  DateTime? _lastBatteryInfoUpdate;

  @override
  PowerState build() {
    // Listen for updates to track timestamps
    ref.listen(contactorStateProvider, (prev, next) {
      if (next.hasValue) _lastContactorUpdate = DateTime.now();
    });
    ref.listen(vcuPduStatusProvider, (prev, next) {
      if (next.hasValue) _lastPduStatusUpdate = DateTime.now();
    });
    ref.listen(powerSubsystemHealthProvider, (prev, next) {
      if (next.hasValue) _lastBatteryHealthUpdate = DateTime.now();
    });
    ref.listen(batteryInfoProvider, (prev, next) {
      if (next.hasValue) _lastBatteryInfoUpdate = DateTime.now();
    });

    final now = DateTime.now();
    const stalenessThreshold = Duration(seconds: 5);

    bool isStale(DateTime? lastUpdate) =>
        lastUpdate == null || now.difference(lastUpdate) > stalenessThreshold;

    return PowerState(
      contactorState: isStale(_lastContactorUpdate) ? null : ref.read(contactorStateProvider).value,
      vcuPduStatus: isStale(_lastPduStatusUpdate) ? null : ref.read(vcuPduStatusProvider).value,
      powerHealth: isStale(_lastBatteryHealthUpdate) ? null : ref.read(powerSubsystemHealthProvider).value,
      batteryInfo: isStale(_lastBatteryInfoUpdate) ? null : ref.read(batteryInfoProvider).value,
    );
  }
}
