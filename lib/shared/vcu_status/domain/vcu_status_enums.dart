enum VcuOperationalState {
  idle,
  keyOn,
  drive,
  unknown;

  static VcuOperationalState fromInt(int value) {
    return switch (value) {
      1 => VcuOperationalState.idle,
      2 => VcuOperationalState.keyOn,
      3 => VcuOperationalState.drive,
      _ => VcuOperationalState.unknown,
    };
  }

  String get label => switch (this) {
    VcuOperationalState.idle => 'Idle',
    VcuOperationalState.keyOn => 'Key ON',
    VcuOperationalState.drive => 'Drive',
    VcuOperationalState.unknown => 'Unknown',
  };
}

enum GenericState {
  disabled,
  disengaged,
  engaged,
  unknown;

  static GenericState fromInt(int value) {
    return switch (value) {
      0 => GenericState.disabled,
      1 => GenericState.disengaged,
      2 => GenericState.engaged,
      _ => GenericState.unknown,
    };
  }

  String get label => switch (this) {
    GenericState.disabled => 'Disabled',
    GenericState.disengaged => 'Disengaged',
    GenericState.engaged => 'Engaged',
    GenericState.unknown => 'Unknown',
  };
}
