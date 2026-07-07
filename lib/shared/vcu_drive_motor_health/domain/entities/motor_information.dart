import 'motor_status.dart';

class MotorInformation {
  final MotorStatus overSpeed;
  final MotorStatus overload;
  final MotorStatus phaseLoss;
  final MotorStatus brake;
  final MotorStatus encoderFault;
  final MotorStatus overTemp;
  final MotorStatus hallFault;
  final MotorStatus stalled;

  const MotorInformation({
    required this.overSpeed,
    required this.overload,
    required this.phaseLoss,
    required this.brake,
    required this.encoderFault,
    required this.overTemp,
    required this.hallFault,
    required this.stalled,
  });

  @override
  String toString() {
    return 'MotorInfo(overSpeed: $overSpeed, overload: $overload, phaseLoss: $phaseLoss, brake: $brake, encoder: $encoderFault, overTemp: $overTemp, hall: $hallFault, stalled: $stalled)';
  }
}
