import '../../enums/pdu_channel_state_enum.dart';

class VcuPduStatusEntity {
  final PduChannelState channel1State;
  final PduChannelState channel2State;
  final PduChannelState channel3State;
  final PduChannelState channel4State;
  final PduChannelState channel5State;
  final PduChannelState channel6State;
  final PduChannelState channel7State;
  final PduChannelState channel8State;

  const VcuPduStatusEntity({
    required this.channel1State,
    required this.channel2State,
    required this.channel3State,
    required this.channel4State,
    required this.channel5State,
    required this.channel6State,
    required this.channel7State,
    required this.channel8State,
  });

  @override
  String toString() {
    return 'VcuPduStatusEntity(\n'
        '  channel1: $channel1State,\n'
        '  channel2: $channel2State,\n'
        '  channel3: $channel3State,\n'
        '  channel4: $channel4State,\n'
        '  channel5: $channel5State,\n'
        '  channel6: $channel6State,\n'
        '  channel7: $channel7State,\n'
        '  channel8: $channel8State\n'
        ')';
  }
}
