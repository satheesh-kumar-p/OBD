abstract final class AppConstants {

  static const bool useMockBackends = true;

  // static const String mavlinkHost = '192.168.168.98';
  static const String mavlinkHost = '10.10.60.147';
  static const int mavlinkPort = 7000;

  static const String primaryLinkId = 'ugv_obd';

  static const int obdSystemId = 1;
  static const int obdComponentId = 157;

  static const int ugvSystemId = 1;
  static const int ugvComponentId = 191;

  // Heartbeat
  static const Duration heartbeatLostTimeout = Duration(seconds: 3);
  static const Duration heartbeatSendInterval = Duration(seconds: 1);

  // ── Time Sync
  static const Duration timeSyncInterval = Duration(seconds: 10);



}