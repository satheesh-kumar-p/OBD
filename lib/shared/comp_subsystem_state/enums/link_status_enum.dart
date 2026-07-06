enum LinkStatus {
  badValue(-1, 'BAD VALUE'),
  disconnected(0, 'DISCONNECTED'),
  healthy(1, 'HEALTHY'),
  degraded(2, 'DEGRADED');

  const LinkStatus(this.value, this.label);
  final int value;
  final String label;
}
