enum PowerStateEnum {
  unknown(0, 'UNKNOWN'),
  on(1, 'ON'),
  off(2, 'OFF');

  const PowerStateEnum(this.value, this.label);
  final int value;
  final String label;

  static PowerStateEnum fromInt(int value) {
    return PowerStateEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PowerStateEnum.unknown,
    );
  }
}
