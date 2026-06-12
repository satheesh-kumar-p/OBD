class McTempVoltEntity {
  final double rearMcVoltage;
  final double frontMcVoltage;
  final int rearMcTemp;
  final int frontMcTemp;

  const McTempVoltEntity({
    required this.rearMcVoltage,
    required this.frontMcVoltage,
    required this.rearMcTemp,
    required this.frontMcTemp,
  });

  @override
  String toString() {
    return 'McTempVoltEntity(rearMcVoltage: $rearMcVoltage V, frontMcVoltage: $frontMcVoltage V, rearMcTemp: $rearMcTemp C, frontMcTemp: $frontMcTemp C)';
  }
}
