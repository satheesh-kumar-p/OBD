enum EStopStatus {
  unknown(-1, 'UNKNOWN'),
  released(0, 'RELEASED'),
  engaged(1, 'ENGAGED');

  const EStopStatus(this.value, this.label);
  final int value;
  final String label;
}
