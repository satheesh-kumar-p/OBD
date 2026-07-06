enum ConnectionState {
  badValue(-1, 'BAD VALUE'),
  notConnected(0, 'NOT CONNECTED'),
  connected(1, 'CONNECTED');

  const ConnectionState(this.value, this.label);
  final int value;
  final String label;
}
