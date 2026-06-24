import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/hv_battery_health_entity.dart';
import '../../enums/hv_battery_faults.dart';
import '../../enums/power_subsystem_status.dart';

class VcuPowerSubsystemHealthMapper extends CanExtractionStrategy<HvBatteryHealthEntity> {
  static final int id = 0x205;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'hvBatteryFaults',
      startBit: 34,
      endBit: 46,
    ),
  ];

  @override
  HvBatteryHealthEntity build(Map<String, dynamic> values) {
    final int rawFaults = values['hvBatteryFaults'];
    return HvBatteryHealthEntity(
      singleCellOvervoltage: _toStatus(HvBatteryFaults.singleCellOvervoltage.isFaulty(rawFaults)),
      singleCellUndervoltage: _toStatus(HvBatteryFaults.singleCellUndervoltage.isFaulty(rawFaults)),
      packOvervoltage: _toStatus(HvBatteryFaults.packOvervoltage.isFaulty(rawFaults)),
      packUndervoltage: _toStatus(HvBatteryFaults.packUndervoltage.isFaulty(rawFaults)),
      chargeOverTemperature: _toStatus(HvBatteryFaults.chargeOverTemperature.isFaulty(rawFaults)),
      chargeLowTemperature: _toStatus(HvBatteryFaults.chargeLowTemperature.isFaulty(rawFaults)),
      dischargeOverTemperature: _toStatus(HvBatteryFaults.dischargeOverTemperature.isFaulty(rawFaults)),
      dischargeLowTemperature: _toStatus(HvBatteryFaults.dischargeLowTemperature.isFaulty(rawFaults)),
      chargeOvercurrent: _toStatus(HvBatteryFaults.chargeOvercurrent.isFaulty(rawFaults)),
      dischargeOvercurrent: _toStatus(HvBatteryFaults.dischargeOvercurrent.isFaulty(rawFaults)),
      shortCircuitProtection: _toStatus(HvBatteryFaults.shortCircuitProtection.isFaulty(rawFaults)),
      frontDetectionIcError: _toStatus(HvBatteryFaults.frontDetectionIcError.isFaulty(rawFaults)),
      softwareLockMos: _toStatus(HvBatteryFaults.softwareLockMos.isFaulty(rawFaults)),
    );
  }

  PowerSubsystemStatus _toStatus(bool isFaulty) => isFaulty ? PowerSubsystemStatus.fault : PowerSubsystemStatus.healthy;
}
