import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../shared/vcu_contactor_state/di/contactor_state_providers.dart';
import '../../shared/vcu_lv_pdu_load1/lv_pdu_load_ch1_4_providers.dart';
import '../../shared/vcu_lv_pdu_load2/lv_pdu_load_ch5_8_providers.dart';
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
  DateTime? _lastPduCh1_4Update;
  DateTime? _lastPduCh5_8Update;

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
    ref.listen(lvPduLoadCh1_4Provider, (prev, next) {
      if (next.hasValue) _lastPduCh1_4Update = DateTime.now();
    });
    ref.listen(lvPduLoadCh5_8Provider, (prev, next) {
      if (next.hasValue) _lastPduCh5_8Update = DateTime.now();
    });

    // Watch staleness ticker
    ref.watch(stalenessTickerProvider);

    final now = DateTime.now();
    const stalenessThreshold = Duration(seconds: 5);

    bool isStale(DateTime? lastUpdate) =>
        lastUpdate == null || now.difference(lastUpdate) > stalenessThreshold;

    return PowerState(
      contactorState: isStale(_lastContactorUpdate) ? null : ref.read(contactorStateProvider).value,
      vcuPduStatus: isStale(_lastPduStatusUpdate) ? null : ref.read(vcuPduStatusProvider).value,
      powerHealth: isStale(_lastBatteryHealthUpdate) ? null : ref.read(powerSubsystemHealthProvider).value,
      batteryInfo: isStale(_lastBatteryInfoUpdate) ? null : ref.read(batteryInfoProvider).value,
      pduCh1_4: isStale(_lastPduCh1_4Update) ? null : ref.read(lvPduLoadCh1_4Provider).value,
      pduCh5_8: isStale(_lastPduCh5_8Update) ? null : ref.read(lvPduLoadCh5_8Provider).value,
    );
  }
}
