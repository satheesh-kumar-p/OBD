class BatteryInfoEntity {
  final int hvBatterySoc;
  final int lvBatterySoc;
  final double lvBatteryVoltage;

  BatteryInfoEntity({
    required this.hvBatterySoc,
    required this.lvBatterySoc,
    required this.lvBatteryVoltage,
  });

  @override
  String toString() => 'Battery(HV Battery SOC: $hvBatterySoc%, LV Battery SOC: $lvBatterySoc%, LV Battery Voltage: $lvBatteryVoltage v';
}
