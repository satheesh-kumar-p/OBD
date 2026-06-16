import '../enums/dispatch_strategy_enum.dart';

class MessageConfig {
  final int messageId;
  final DispatchStrategy strategy;
  final double frequencyHz;

  const MessageConfig({
    required this.messageId,
    this.strategy = DispatchStrategy.passThrough,
    this.frequencyHz = 0,
  });

  const MessageConfig.sample(this.messageId, this.frequencyHz)
      : strategy = DispatchStrategy.throttle;

  const MessageConfig.passThrough(this.messageId)
      : strategy = DispatchStrategy.passThrough,
        frequencyHz = 0;

  int get intervalMs => frequencyHz > 0 ? (1000 / frequencyHz).round() : 0;
}