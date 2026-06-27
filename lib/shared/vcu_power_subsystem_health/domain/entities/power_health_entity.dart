import 'hv_battery_health_entity.dart';
import 'lv_pdu_health_entity.dart';

class PowerHealthEntity {
  final HvBatteryHealthEntity hvBattery;
  final LvPduHealthEntity lvPdu;

  const PowerHealthEntity({
    required this.hvBattery,
    required this.lvPdu,
  });

  @override
  String toString() {
    return 'PowerHealthEntity(hvBattery: $hvBattery, lvPdu: $lvPdu)';
  }

}
