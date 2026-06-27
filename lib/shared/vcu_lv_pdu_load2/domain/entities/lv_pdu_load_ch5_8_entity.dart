class LvPduLoadCh5_8Entity {
  final double channel5Current;
  final double channel6Current;
  final double channel7Current;
  final double channel8Current;

  const LvPduLoadCh5_8Entity({
    required this.channel5Current,
    required this.channel6Current,
    required this.channel7Current,
    required this.channel8Current,
  });

  @override
  String toString() {
    return 'PduVcuStatusCh5_8Entity(\n'
        '  ch5Current: ${channel5Current}A,\n'
        '  ch6Current: ${channel6Current}A,\n'
        '  ch7Current: ${channel7Current}A,\n'
        '  ch8Current: ${channel8Current}A\n'
        ')';
  }
}
