import 'hv_battery_health_entity.dart';
import 'lv_battery_health_entity.dart';

class PowerHealthEntity {
  final HvBatteryHealthEntity hvBattery;
  final LvBatteryHealthEntity lvBattery;

  const PowerHealthEntity({
    required this.hvBattery,
    required this.lvBattery,
  });

  @override
  String toString() {
    return 'PowerHealthEntity(hvBattery: $hvBattery, lvBattery: $lvBattery)';
  }
}
