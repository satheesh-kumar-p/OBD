enum ContactorState {
  open(0),
  closed(1);

  final int value;
  const ContactorState(this.value);

  static ContactorState fromValue(int value) {
    return ContactorState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ContactorState.open,
    );
  }
}
