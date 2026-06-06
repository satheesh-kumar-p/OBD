class BatteryInfoEntity {
  final int hvBatterySoc;
  final int lvBatterySoc;

  BatteryInfoEntity({required this.hvBatterySoc, required this.lvBatterySoc});

  @override
  String toString() => 'Battery(HV Battery SOC: $hvBatterySoc%, LV Battery SOC: $lvBatterySoc%';
}
