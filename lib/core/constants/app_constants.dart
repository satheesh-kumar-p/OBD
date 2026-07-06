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

  // Staleness Configuration
  static const Duration staleThreshold = Duration(seconds: 5);

  // CAN Message ID Whitelist
  // Any ID not in this list will be ignored by the MessageDispatcher
  static const Set<int> whitelistedMessageIds = {
    0x200, // Battery Info
    0x203, // System Health Info
    0x204, // Drive Fault Info
    0x20C, // Radio/Compute State
    0x211, // MC Temp & Voltage
    0x219, // VCU Status (Common Page Information)
  };

  // Centralized Message Dispatch Rules
  static const List<MessageConfig> dispatchConfigs = [];
}
