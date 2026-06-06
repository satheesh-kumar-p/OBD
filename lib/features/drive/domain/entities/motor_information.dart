import './status.dart';

class MotorInformation {
  final Status overSpeed;
  final Status overload;
  final Status phaseLoss;
  final Status brake;
  final Status encoderFault;
  final Status overTemp;
  final Status hallFault;
  final Status stalled;

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
}
