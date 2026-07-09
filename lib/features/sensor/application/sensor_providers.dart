import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/comp_sensor_subsystem_health_1/sensor_1_health_providers.dart';
import '../../../shared/comp_sensor_subsystem_health_2/sensor_2_health_providers.dart';
import '../../../shared/vcu_subsystem_power_state/vcu_subsystem_power_state_providers.dart';
import 'sensor_state.dart';

final sensorStateProvider = Provider<SensorState>((ref) {
  final sensor1 = ref.watch(sensor1HealthProvider).value;
  final sensor2 = ref.watch(sensor2HealthProvider).value;
  final powerState = ref.watch(vcuSubsystemPowerStateProvider).value;

  return SensorState(
    sensor1: sensor1,
    sensor2: sensor2,
    powerState: powerState,
  );
});
