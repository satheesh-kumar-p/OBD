class PduVcuStatusCh1_4Entity {
  final double channel1Current;
  final double channel2Current;
  final double channel3Current;
  final double channel4Current;

  const PduVcuStatusCh1_4Entity({
    required this.channel1Current,
    required this.channel2Current,
    required this.channel3Current,
    required this.channel4Current,
  });

  @override
  String toString() {
    return 'PduVcuStatusCh1_4Entity(\n'
        '  ch1Current: ${channel1Current}A,\n'
        '  ch2Current: ${channel2Current}A,\n'
        '  ch3Current: ${channel3Current}A,\n'
        '  ch4Current: ${channel4Current}A\n'
        ')';
  }
}
