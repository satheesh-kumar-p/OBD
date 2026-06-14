import 'can_dispatcher.dart';

/// Centralized configuration for CAN message dispatching.
/// 
/// This file defines how frequently different CAN messages should be 
/// emitted to the rest of the application.
class CanDispatchConfigs {
  static const List<MessageConfig> defaultConfigs = [
    // Global Time Info (0x202) - Pass-through (Low frequency)
    MessageConfig.passThrough(0x202),

    // Time Sync (0x206) - 10Hz for smooth clock
    MessageConfig.sample(0x206, 2.0),
  ];
}
