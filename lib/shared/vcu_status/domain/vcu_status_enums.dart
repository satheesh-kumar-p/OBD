enum VcuOperationalState {
  idle(1, 'IDLE'),
  keyOn(2, 'KEY ON'),
  drive(3, 'DRIVE'),
  unknown(-1, 'UNKNOWN');

  const VcuOperationalState(this.value, this.label);
  final int value;
  final String label;

  static VcuOperationalState fromInt(int value) {
    return VcuOperationalState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VcuOperationalState.unknown,
    );
  }
}

enum GenericState {
  disabled(0, 'DISABLED'),
  disengaged(1, 'DISENGAGED'),
  engaged(2, 'ENGAGED'),
  unknown(-1, 'UNKNOWN');

  const GenericState(this.value, this.label);
  final int value;
  final String label;

  static GenericState fromInt(int value) {
    return GenericState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GenericState.unknown,
    );
  }
}

enum ArmModeEnum {
  unknown(-1, 'UNKNOWN'),
  disarmed(1, 'DISARMED'),
  armed(2, 'ARMED'),
  override(3, 'OVERRIDE');

  const ArmModeEnum(this.value, this.label);
  final int value;
  final String label;

  static ArmModeEnum fromInt(int value) {
    return ArmModeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ArmModeEnum.unknown,
    );
  }
}

enum DriveModeEnum {
  unknown(-1, 'UNKNOWN'),
  speed(1, 'SPEED'),
  torque(2, 'TORQUE'),
  torqueWithSpeedLimit(3, 'TRQ W SL');

  const DriveModeEnum(this.value, this.label);
  final int value;
  final String label;

  static DriveModeEnum fromInt(int value) {
    return DriveModeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DriveModeEnum.unknown,
    );
  }
}

enum DriveModeLimitEnum {
  unknown(-1, 'UNKNOWN'),
  low(1, 'LOW'),
  medium(2, 'MEDIUM'),
  high(3, 'HIGH');

  const DriveModeLimitEnum(this.value, this.label);
  final int value;
  final String label;

  static DriveModeLimitEnum fromInt(int value) {
    return DriveModeLimitEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DriveModeLimitEnum.unknown,
    );
  }
}

enum TowModeEnum {
  disengaged(0, 'DISENGAGED'),
  engaged(1, 'ENGAGED'),
  unknown(-1, 'UNKNOWN');

  const TowModeEnum(this.value, this.label);
  final int value;
  final String label;

  static TowModeEnum fromInt(int value) {
    return TowModeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TowModeEnum.unknown,
    );
  }
}

enum EmergencyEnum {
  disengaged(1, 'DISENGAGED'),
  engaged(2, 'ENGAGED'),
  disabled(3, 'DISABLED'),
  unknown(-1, 'UNKNOWN');

  const EmergencyEnum(this.value, this.label);
  final int value;
  final String label;

  static EmergencyEnum fromInt(int value) {
    return EmergencyEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EmergencyEnum.unknown,
    );
  }
}

enum AutonomyModeEnum {
  unknown(-1, 'UNKNOWN'),
  modeA(1, 'MODE A'),
  modeB(2, 'MODE B'),
  modeC(3, 'MODE C'),
  modeD(4, 'MODE D'),
  modeE(5, 'MODE E');

  const AutonomyModeEnum(this.value, this.label);
  final int value;
  final String label;

  static AutonomyModeEnum fromInt(int value) {
    return AutonomyModeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AutonomyModeEnum.unknown,
    );
  }
}

enum HoldStateEnum {
  disengaged(1, 'DISENGAGED'),
  engaged(2, 'ENGAGED'),
  unknown(-1, 'UNKNOWN');

  const HoldStateEnum(this.value, this.label);
  final int value;
  final String label;

  static HoldStateEnum fromInt(int value) {
    return HoldStateEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => HoldStateEnum.unknown,
    );
  }
}


