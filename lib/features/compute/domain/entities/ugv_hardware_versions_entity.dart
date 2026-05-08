class UgvHardwareVersionsEntity {
  final String motorControllerSw;
  final String uhfRadioSw;
  final String lBandRadioSw;

  // you can keep checksums as List<int> or wrap in a type if you want
  final List<int> motorControllerChecksum;
  final List<int> uhfRadioChecksum;
  final List<int> lBandRadioChecksum;

  const UgvHardwareVersionsEntity({
    required this.motorControllerSw,
    required this.uhfRadioSw,
    required this.lBandRadioSw,
    required this.motorControllerChecksum,
    required this.uhfRadioChecksum,
    required this.lBandRadioChecksum,
  });
}