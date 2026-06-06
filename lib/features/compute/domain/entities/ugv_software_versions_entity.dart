import '../../enums/firmware_version_type.dart';

class UgvSoftwareVersionsEntity {
  final FirmwareVersion32 compSoftware;
  final FirmwareVersion32 vcuSoftware;
  final FirmwareVersion32 obdSoftware;
  final FirmwareVersion32 hcSoftware;
  final FirmwareVersion32 gcsSoftware;

  const UgvSoftwareVersionsEntity({
    required this.compSoftware,
    required this.vcuSoftware,
    required this.obdSoftware,
    required this.hcSoftware,
    required this.gcsSoftware,
  });
}