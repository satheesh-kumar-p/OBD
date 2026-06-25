enum SubsystemFaultState {
  unknown(0, 'UNKNOWN'),
  noFault(1, 'NO FAULT'),
  faulty(2, 'FAULTY'),
  badValue(-1, 'BAD VALUE');

  const SubsystemFaultState(this.value, this.label);
  final int value;
  final String label;

  SubsystemFaultState get displayStatus => this;
}
