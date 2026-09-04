import '../enums/transport_type.dart';
import '../dispatcher/message_config.dart';

abstract final class AppConstants {
  // Communication Layer
  static const TransportType transportType = TransportType.udp;

  // UDP Configuration
  static const int listenPort = 5005;
  static const String sendAddress = '10.10.60.91';
  static const int sendPort = 5001;

  // UDP Configuration for checksum data.
  // The checksum packets are expected from the same remote UDP service that
  // provides CAN data, but on the checksum port 49152.
  static const int checksumListenPort = 49153;

  // TCP Configuration
  static const String tcpHost = '192.168.1.10';
  static const int tcpPort = 5002;

  // Staleness Configuration
  static const Duration staleThreshold = Duration(seconds: 5);

  // CAN Message ID Whitelist
  // Any ID not in this list will be ignored by the MessageDispatcher
  static const Set<int> whitelistedMessageIds = {
    0x199, // Compute Subsystem Information
    0x200, // Battery Info
    0x203, // VCU Subsystem Information
    0x204, // Drive Motor Fault Information
    0x205, // VCU Power Subsystem Health
    0x207, // VCU Contactor Fault Information
    0x210, // VCU PDU Status
    0x213, // VCU Interface Health
    0x219, // VCU Status (Common Page Information)
    0x221, // VCU Main Compute Information
    0x222, // VCU Subsystem Power State
    0x225, // Secondary Compute Status
    0x227, // Drive Motor Controller Information
    0x22B, // Sensor 1 Health Information (UHF Radio)
    0x22D, // Sensor 2 Health Information (L-Band, GNSS, etc.)
  };

  // Centralized Message Dispatch Rules
  static const List<MessageConfig> dispatchConfigs = [];
}