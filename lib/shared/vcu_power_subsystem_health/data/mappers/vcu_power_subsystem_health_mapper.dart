import '../../../../core/comm/can_bus/can_extraction_strategy.dart';
import '../../../../core/comm/can_bus/can_field.dart';
import '../../domain/entities/hv_battery_health_entity.dart';
import '../../domain/entities/lv_pdu_health_entity.dart';
import '../../domain/entities/power_health_entity.dart';
import '../../enums/hv_battery_faults.dart';
import '../../enums/lv_pdu_channel_faults.dart';
import '../../enums/power_subsystem_status.dart';

class VcuPowerSubsystemHealthMapper extends CanExtractionStrategy<PowerHealthEntity> {
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
    const CanField<int>(name: 'lvPduCh1Faults', startBit: 31, endBit: 33),
    const CanField<int>(name: 'lvPduCh2Faults', startBit: 28, endBit: 30),
    const CanField<int>(name: 'lvPduCh3Faults', startBit: 25, endBit: 27),
    const CanField<int>(name: 'lvPduCh4Faults', startBit: 22, endBit: 24),
    const CanField<int>(name: 'lvPduCh5Faults', startBit: 19, endBit: 21),
    const CanField<int>(name: 'lvPduCh6Faults', startBit: 16, endBit: 18),
    const CanField<int>(name: 'lvPduCh7Faults', startBit: 13, endBit: 15),
    const CanField<int>(name: 'lvPduCh8Faults', startBit: 10, endBit: 12),
  ];

  @override
  PowerHealthEntity build(Map<String, dynamic> values) {
    final int rawHvBattery = values['hvBatteryFaults'];
    
    final hvBattery = HvBatteryHealthEntity(
      singleCellOvervoltage: _toStatus(HvBatteryFaults.singleCellOvervoltage.isFaulty(rawHvBattery)),
      singleCellUndervoltage: _toStatus(HvBatteryFaults.singleCellUndervoltage.isFaulty(rawHvBattery)),
      packOvervoltage: _toStatus(HvBatteryFaults.packOvervoltage.isFaulty(rawHvBattery)),
      packUndervoltage: _toStatus(HvBatteryFaults.packUndervoltage.isFaulty(rawHvBattery)),
      chargeOverTemperature: _toStatus(HvBatteryFaults.chargeOverTemperature.isFaulty(rawHvBattery)),
      chargeLowTemperature: _toStatus(HvBatteryFaults.chargeLowTemperature.isFaulty(rawHvBattery)),
      dischargeOverTemperature: _toStatus(HvBatteryFaults.dischargeOverTemperature.isFaulty(rawHvBattery)),
      dischargeLowTemperature: _toStatus(HvBatteryFaults.dischargeLowTemperature.isFaulty(rawHvBattery)),
      chargeOvercurrent: _toStatus(HvBatteryFaults.chargeOvercurrent.isFaulty(rawHvBattery)),
      dischargeOvercurrent: _toStatus(HvBatteryFaults.dischargeOvercurrent.isFaulty(rawHvBattery)),
      shortCircuitProtection: _toStatus(HvBatteryFaults.shortCircuitProtection.isFaulty(rawHvBattery)),
      frontDetectionIcError: _toStatus(HvBatteryFaults.frontDetectionIcError.isFaulty(rawHvBattery)),
      softwareLockMos: _toStatus(HvBatteryFaults.softwareLockMos.isFaulty(rawHvBattery)),
    );

    final lvPdu = LvPduHealthEntity(
      channels: [
        _buildChannelHealth(1, values['lvPduCh1Faults']),
        _buildChannelHealth(2, values['lvPduCh2Faults']),
        _buildChannelHealth(3, values['lvPduCh3Faults']),
        _buildChannelHealth(4, values['lvPduCh4Faults']),
        _buildChannelHealth(5, values['lvPduCh5Faults']),
        _buildChannelHealth(6, values['lvPduCh6Faults']),
        _buildChannelHealth(7, values['lvPduCh7Faults']),
        _buildChannelHealth(8, values['lvPduCh8Faults']),
      ],
    );

    return PowerHealthEntity(hvBattery: hvBattery, lvPdu: lvPdu);
  }

  LvPduChannelHealth _buildChannelHealth(int num, int raw) {
    return LvPduChannelHealth(
      channelNumber: num,
      shortCircuit: _toStatus(LvPduChannelFaults.shortCircuit.isFaulty(raw)),
      currentLimit: _toStatus(LvPduChannelFaults.currentLimit.isFaulty(raw)),
      openCircuit: _toStatus(LvPduChannelFaults.openCircuit.isFaulty(raw)),
    );
  }

  PowerSubsystemStatus _toStatus(bool isFaulty) => isFaulty ? PowerSubsystemStatus.fault : PowerSubsystemStatus.healthy;
}
