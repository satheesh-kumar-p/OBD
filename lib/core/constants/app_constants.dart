abstract final class AppConstants {

  static const String mavlinkHost = '192.168.168.98';
  static const int mavlinkPort = 7000;

  static const String primaryLinkId = 'ugv_obd';

  static const int obdSystemId = 1;
  static const int obdComponentId = 157;

  static const int ugvSystemId = 1;
  static const int ugvComponentId = 191;

  static const Duration timeSyncInterval = Duration(seconds: 10);



}