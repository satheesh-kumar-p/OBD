import '../../enums/contactor_fault_enum.dart';

class VcuContactorStateEntity {
  final ContactorState preChargeContFault;
  final ContactorState mcContFault;
  final ContactorState ipDcDcContFault;
  final ContactorState hvChargeContFault;
  final ContactorState lvChargeContFault;
  final ContactorState opDcDcContFault;

  const VcuContactorStateEntity({
    required this.preChargeContFault,
    required this.mcContFault,
    required this.ipDcDcContFault,
    required this.hvChargeContFault,
    required this.lvChargeContFault,
    required this.opDcDcContFault,
  });

  @override
  String toString() {
    return 'VcuContactorStateEntity(\n'
        '  preChargeContFault: $preChargeContFault,\n'
        '  mcContFault: $mcContFault,\n'
        '  ipDcDcContFault: $ipDcDcContFault,\n'
        '  hvChargeContFault: $hvChargeContFault,\n'
        '  lvChargeContFault: $lvChargeContFault,\n'
        '  opDcDcContFault: $opDcDcContFault\n'
        ')';
  }
}
