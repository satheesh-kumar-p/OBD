class UgvComponentVersionEntity {
  final int major;
  final int minor;
  final int patch;
  int? firmwareType;

  UgvComponentVersionEntity({
    required this.major,
    required this.minor,
    required this.patch,
    this.firmwareType
  });

}