enum SubsystemStatus {
  noCommunication(1),
  healthy(2),
  unhealthy(3);

  final int value;
  const SubsystemStatus(this.value);

  SubsystemStatus get displayStatus => this;
}