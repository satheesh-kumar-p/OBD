import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/hv_battery_health_entity.dart';
import '../../domain/entities/lv_battery_health_entity.dart';
import '../../domain/entities/power_health_entity.dart';
import '../../enums/hv_battery_faults.dart';
import '../../enums/lv_battery_faults.dart';
import '../../enums/power_subsystem_status.dart';

class VcuPowerSubsystemHealthMapper extends CanExtractionStrategy<PowerHealthEntity> {
  static final int id = 0x205;

  @override
  int get messageId => id;

  @override
  List<CanField<dynamic>> get fields => [
    const CanField<int>(
      name: 'hvBatteryFaults',
      startBit: 32,
      endBit: 46,
    ),
    const CanField<int>(
      name: 'lvBatteryFaults',
      startBit: 28,
      endBit: 31,
    ),
  ];

  @override
  PowerHealthEntity build(Map<String, dynamic> values) {
    final int rawHvBattery = values['hvBatteryFaults'];
    final int rawLvBattery = values['lvBatteryFaults'];

    final hvBattery = HvBatteryHealthEntity(
      singleCellOvervoltage: _toStatus(rawHvBattery, HvBatteryFaults.singleCellOvervoltage.bit),
      singleCellUndervoltage: _toStatus(rawHvBattery, HvBatteryFaults.singleCellUndervoltage.bit),
      packOvervoltage: _toStatus(rawHvBattery, HvBatteryFaults.packOvervoltage.bit),
      packUndervoltage: _toStatus(rawHvBattery, HvBatteryFaults.packUndervoltage.bit),
      chargeOverTemperature: _toStatus(rawHvBattery, HvBatteryFaults.chargeOverTemperature.bit),
      chargeLowTemperature: _toStatus(rawHvBattery, HvBatteryFaults.chargeLowTemperature.bit),
      dischargeOverTemperature: _toStatus(rawHvBattery, HvBatteryFaults.dischargeOverTemperature.bit),
      dischargeLowTemperature: _toStatus(rawHvBattery, HvBatteryFaults.dischargeLowTemperature.bit),
      chargeOvercurrent: _toStatus(rawHvBattery, HvBatteryFaults.chargeOvercurrent.bit),
      dischargeOvercurrent: _toStatus(rawHvBattery, HvBatteryFaults.dischargeOvercurrent.bit),
      shortCircuitProtection: _toStatus(rawHvBattery, HvBatteryFaults.shortCircuitProtection.bit),
      frontDetectionIcError: _toStatus(rawHvBattery, HvBatteryFaults.frontDetectionIcError.bit),
      softwareLockMos: _toStatus(rawHvBattery, HvBatteryFaults.softwareLockMos.bit),
      cycleLifeFault: _toStatus(rawHvBattery, HvBatteryFaults.cycleLifeFault.bit),
      capacityFault: _toStatus(rawHvBattery, HvBatteryFaults.capacityFault.bit),
    );

    final lvBattery = LvBatteryHealthEntity(
      deepDischarge: _toStatus(rawLvBattery, LvBatteryFaults.deepDischarge.bit),
      underVoltage: _toStatus(rawLvBattery, LvBatteryFaults.underVoltage.bit),
      overVoltage: _toStatus(rawLvBattery, LvBatteryFaults.overVoltage.bit),
      loadFault: _toStatus(rawLvBattery, LvBatteryFaults.loadFault.bit),
    );

    return PowerHealthEntity(hvBattery: hvBattery, lvBattery: lvBattery);
  }

  PowerSubsystemStatus _toStatus(int rawValue, int bit) {
    return PowerSubsystemStatus.fromInt((rawValue & bit) != 0 ? 1 : 0);
  }
}
