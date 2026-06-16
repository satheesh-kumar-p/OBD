import '../enums/transport_type.dart';
import '../dispatcher/message_config.dart';

abstract final class AppConstants {
  // Communication Layer
  static const TransportType transportType = TransportType.udp;

  // UDP Configuration
  static const int listenPort = 5005;
  static const String sendAddress = '10.10.60.91';
  static const int sendPort = 5001;

  // TCP Configuration
  static const String tcpHost = '192.168.1.10';
  static const int tcpPort = 5002;


  // Centralized Message Dispatch Rules
  static const List<MessageConfig> dispatchConfigs = [
    // Time Sync (0x206)
    MessageConfig.sample(0x206, 2.0),
  ];
}
