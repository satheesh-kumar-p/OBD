import '../../enums/power_subsystem_status.dart';

class LvPduHealthEntity {
  final List<LvPduChannelHealth> channels;

  const LvPduHealthEntity({required this.channels});
}

class LvPduChannelHealth {
  final int channelNumber;
  final PowerSubsystemStatus shortCircuit;
  final PowerSubsystemStatus currentLimit;
  final PowerSubsystemStatus openCircuit;

  const LvPduChannelHealth({
    required this.channelNumber,
    required this.shortCircuit,
    required this.currentLimit,
    required this.openCircuit,
  });
}
