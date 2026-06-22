import '../../enums/contactor_state_enum.dart';

class VcuContactorStateEntity {
  final ContactorState dcDcFeedbackState;
  final ContactorState lvPduFeedbackState;
  final ContactorState lvBatteryFeedbackState;
  final ContactorState prechargeFeedbackState;
  final ContactorState motorControllerFeedbackState;

  const VcuContactorStateEntity({
    required this.dcDcFeedbackState,
    required this.lvPduFeedbackState,
    required this.lvBatteryFeedbackState,
    required this.prechargeFeedbackState,
    required this.motorControllerFeedbackState,
  });

  @override
  String toString() {
    return 'VcuContactorStateEntity(\n'
        '  dcDcFeedback: $dcDcFeedbackState,\n'
        '  lvPduFeedback: $lvPduFeedbackState,\n'
        '  lvBatteryFeedback: $lvBatteryFeedbackState,\n'
        '  prechargeFeedback: $prechargeFeedbackState,\n'
        '  motorControllerFeedback: $motorControllerFeedbackState\n'
        ')';
  }
}
