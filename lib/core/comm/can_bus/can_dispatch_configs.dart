import 'can_dispatcher.dart';

/// Centralized configuration for CAN message dispatching.
/// 
/// This file defines how frequently different CAN messages should be 
/// emitted to the rest of the application.
class CanDispatchConfigs {
  static const List<MessageConfig> defaultConfigs = [
    // Battery Info (0x101) - Sample at 5Hz to avoid UI flicker
    MessageConfig.sample(0x101, 5.0),
    
    // Drive Info (0x102) - Sample at 5Hz
    MessageConfig.sample(0x102, 5.0),
    
    // Mode Info (0x103) - Pass-through (usually low frequency/critical)
    MessageConfig.passThrough(0x103),
    
    // E-Stop Info (0x104) - Pass-through (Critical safety)
    MessageConfig.passThrough(0x104),

    // Time Sync (0x206) - High frequency (50Hz) input, sample at 5Hz for UI
    MessageConfig.sample(0x206, 5.0),
    
    // Global Time Info (0x202) - Low frequency, pass-through
    MessageConfig.passThrough(0x202),
  ];
}
