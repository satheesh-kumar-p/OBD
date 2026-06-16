import 'package:scout_obd/core/enums/can_enums.dart';
import '../enums/transport_type.dart';
import '../dispatcher/message_config.dart';

abstract final class AppConstants {
  // CAN (Legacy Serial)
  static const String canPortName = '/dev/can';
  static const CanBaudRate canBaudRate = CanBaudRate.bps500k;

  // Communication Layer
  static const TransportType transportType = TransportType.udp;

  // UDP Configuration
  static const int listenPort = 5000;
  static const String sendAddress = '192.168.1.10';
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
