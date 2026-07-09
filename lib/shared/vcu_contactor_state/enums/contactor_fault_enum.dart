enum ContactorState {
  healthy(0, 'HEALTHY'),
  faulty(1, 'FAULTY'),
  unknown(-1, 'UNKNOWN');

  const ContactorState(this.value, this.label);
  final int value;
  final String label;

  static ContactorState fromInt(int value) {
    return ContactorState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ContactorState.unknown,
    );
  }
}
