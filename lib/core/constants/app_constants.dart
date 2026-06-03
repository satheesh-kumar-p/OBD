import 'package:scout_obd/core/enums/can_enums.dart';

abstract final class AppConstants {

  static const bool useMockBackends = false;

  static const String mavlinkHost = '192.168.168.98';
  // static const String mavlinkHost = '10.10.60.147';
  static const int mavlinkPort = 7000;

  static const String canPortName = '/dev/can';
  static const CanBaudRate canBaudRate = CanBaudRate.bps500k;

  static const String primaryLinkId = 'ugv_obd';

  static const int obdSystemId = 1;
  static const int obdComponentId = 157;

  static const int ugvSystemId = 1;
  static const int ugvComponentId = 191;

  // Heartbeat
  static const Duration heartbeatLostTimeout = Duration(seconds: 3);
  static const Duration heartbeatSendInterval = Duration(seconds: 1);

}
