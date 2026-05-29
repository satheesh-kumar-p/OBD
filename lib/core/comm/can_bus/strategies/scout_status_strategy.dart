import '../../../../shared/data/can_message_schema.dart';

class ScoutStatusStrategy extends CanExtractionStrategy {
  @override
  List<CanField> get fields => [
    const CanField<int>(
      name: 'system_state',
      startBit: 0,
      bitLength: 8,
    ),
    const CanField<String>(
      name: 'control_mode',
      startBit: 8,
      bitLength: 8,
      transformer: _mapControlMode,
    ),
    const CanField<double>(
      name: 'battery_voltage',
      startBit: 16,
      bitLength: 16,
      transformer: _toVoltage,
    ),
    const CanField<bool>(
      name: 'emergency_stop',
      startBit: 32,
      bitLength: 1,
    ),
  ];

  static String _mapControlMode(int val) {
    switch(val) {
      case 0: return 'Standby';
      case 1: return 'Manual';
      case 2: return 'Remote';
      default: return 'Unknown';
    }
  }

  static double _toVoltage(int val) => val * 0.1;
}
