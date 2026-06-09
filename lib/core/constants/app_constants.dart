import 'package:scout_obd/core/enums/can_enums.dart';

abstract final class AppConstants {

  static const bool useMockBackends = true;

  static const String canPortName = '/dev/can';
  static const CanBaudRate canBaudRate = CanBaudRate.bps500k;
}
