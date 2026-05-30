class BatteryInfoEntity {
  final int soc;
  final double voltage;

  BatteryInfoEntity({required this.soc, required this.voltage});

  @override
  String toString() => 'Battery(SOC: $soc%, Volt: ${voltage.toStringAsFixed(1)}V)';
}
