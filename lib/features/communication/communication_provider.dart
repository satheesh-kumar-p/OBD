import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/comp_sensor_subsystem_health_1/sensor_1_health_providers.dart';
import '../../shared/comp_sensor_subsystem_health_2/sensor_2_health_providers.dart';
import '../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';
import '../../shared/vcu_subsystem_power_state/vcu_subsystem_power_state_providers.dart';
import 'communication_state.dart';

final communicationStateProvider = Provider<CommunicationState>((ref) {
  final sensor1 = ref.watch(sensor1HealthProvider).value;
  final sensor2 = ref.watch(sensor2HealthProvider).value;
  final radioFault = ref.watch(compSubsystemInfoProvider).value;
  final powerState = ref.watch(vcuSubsystemPowerStateProvider).value;

  return CommunicationState(
    sensor1: sensor1,
    sensor2: sensor2,
    radioFault: radioFault,
    powerState: powerState,
  );
});