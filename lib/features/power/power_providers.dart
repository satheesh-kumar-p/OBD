import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/vcu_contactor_state/di/contactor_state_providers.dart';
import '../../shared/vcu_pdu_status/di/vcu_pdu_status_providers.dart';
import '../../shared/vcu_power_subsystem_health/di/power_subsystem_health_providers.dart';
import '../../shared/vcu_subsystem_state/di/vcu_subsystem_info_providers.dart';
import '../../shared/vcu_subsystem_power_state/vcu_subsystem_power_state_providers.dart';
import 'state/power_state.dart';

final powerStateProvider = Provider<PowerState>((ref) {
  return PowerState(
    contactorState: ref.watch(contactorStateProvider).value,
    vcuPduStatus: ref.watch(vcuPduStatusProvider).value,
    powerHealth: ref.watch(powerSubsystemHealthProvider).value,
    subsystemInfo: ref.watch(vcuSubsystemInfoProvider).value,
    subsystemPowerState: ref.watch(vcuSubsystemPowerStateProvider).value,
  );
});
