import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/sec_comp_hw_health/sec_compute_health_providers.dart';
import '../../../shared/vcu_comp_info/vcu_comp_info_providers.dart';
import '../../../shared/vcu_interface_health/vcu_interface_health_providers.dart';
import '../../../shared/vcu_subsystem_power_state/vcu_subsystem_power_state_providers.dart';
import '../../../shared/vcu_subsystem_state/di/vcu_subsystem_info_providers.dart';
import 'compute_state.dart';

final computeStateProvider = Provider<ComputeScreenState>((ref) {
  return ComputeScreenState(
    mainCompInfo: ref.watch(vcuCompInfoStreamProvider).value,
    secCompInfo: ref.watch(secComputeHealthProvider).value,
    vcuInfo: ref.watch(vcuInterfaceHealthProvider).value,
    subsystemInfo: ref.watch(vcuSubsystemInfoProvider).value,
    powerState: ref.watch(vcuSubsystemPowerStateProvider).value,
  );
});
