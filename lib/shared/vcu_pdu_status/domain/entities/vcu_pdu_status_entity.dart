import '../../enums/pdu_channel_state_enum.dart';

class VcuPduStatusEntity {
  final PduFaultEnum channel1State;
  final PduFaultEnum channel2State;
  final PduFaultEnum channel3State;
  final PduFaultEnum channel4State;
  final PduFaultEnum channel5State;
  final PduFaultEnum channel6State;
  final PduFaultEnum channel7State;
  final PduFaultEnum channel8State;

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
