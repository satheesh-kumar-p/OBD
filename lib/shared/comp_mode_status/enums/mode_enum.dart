enum MainModeEnum {
  unknown(-1, 'UNKNOWN'),
  modeA(1, 'MODE A'),
  modeB(2, 'MODE B'),
  modeC(3, 'MODE C'),
  modeD(4, 'MODE D'),
  modeE(5, 'MODE E');

  const MainModeEnum(this.value, this.label);
  final int value;
  final String label;
}

enum HoldSubModeEnum {
  unknown(-1, 'UNKNOWN'),
  disabled(1, 'DISABLED'),
  enabled(2, 'ENABLED');

  const HoldSubModeEnum(this.value, this.label);
  final int value;
  final String label;
}

enum SpeedModeEnum {
  unknown(-1, 'UNKNOWN'),
  low(1, 'LOW'),
  medium(2, 'MEDIUM'),
  high(3, 'HIGH');

  const SpeedModeEnum(this.value, this.label);
  final int value;
  final String label;
}

enum DriveModeEnum {
  unknown(-1, 'UNKNOWN'),
  speed(1, 'SPEED'),
  torque(2, 'TORQUE'),
  torqueWithSpeedLimit(3, 'TRQ W SL'),
  position(4, 'POSITION');

  const DriveModeEnum(this.value, this.label);
  final int value;
  final String label;
}

enum ArmStatusEnum {
  unknown(-1, 'UNKNOWN'),
  disarmed(1, 'DISARMED'),
  armed(2, 'ARMED'),
  override(3, 'OVERRIDE');

  const ArmStatusEnum(this.value, this.label);
  final int value;
  final String label;
}
