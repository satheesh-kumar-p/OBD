import '../../domain/entities/ugv_hardware_versions_entity.dart';
import '../../domain/entities/ugv_software_versions_entity.dart';
import '../../enums/firmware_version_type.dart';

class UgvSubsystemVersionModel {
  final int type;  // subsystem type

  final int component1Sw;  // uint32_t
  final int component2Sw;
  final int component3Sw;
  final int component4Sw;
  final int component5Sw;

  final List<int> component1Checksum;
  final List<int> component2Checksum;
  final List<int> component3Checksum;
  final List<int> component4Checksum;
  final List<int> component5Checksum;

  const UgvSubsystemVersionModel({
    required this.type,
    required this.component1Sw,
    required this.component2Sw,
    required this.component3Sw,
    required this.component4Sw,
    required this.component5Sw,
    required this.component1Checksum,
    required this.component2Checksum,
    required this.component3Checksum,
    required this.component4Checksum,
    required this.component5Checksum,
  });

  // Only valid when type == 2 (software versions)
  UgvSoftwareVersionsEntity toSoftwareEntity() {
    assert(type == 2, 'UgvSubsystemVersionModel.toSoftwareEntity(): type must be 2 (software)');

    return UgvSoftwareVersionsEntity(
      compSoftware: FirmwareVersion32.fromUint32(component1Sw),
      vcuSoftware:  FirmwareVersion32.fromUint32(component2Sw),
      obdSoftware:  FirmwareVersion32.fromUint32(component3Sw),
      hcSoftware:   FirmwareVersion32.fromUint32(component4Sw),
      gcsSoftware:  FirmwareVersion32.fromUint32(component5Sw),
    );
  }

  // Only valid when type == 3 (hardware versions)
  UgvHardwareVersionsEntity toHardwareEntity() {
    assert(type == 3, 'UgvSubsystemVersionModel.toHardwareEntity(): type must be 3 (hardware)');

    return UgvHardwareVersionsEntity(
      motorControllerSw: rawBytesToString(component1Sw),
      uhfRadioSw:      rawBytesToString(component2Sw),
      lBandRadioSw:    rawBytesToString(component3Sw),
      motorControllerChecksum: component1Checksum,
      uhfRadioChecksum:      component2Checksum,
      lBandRadioChecksum:    component3Checksum,
    );
  }

  // Helper to decode a compact 4-byte string packed in uint32
  // e.g., 0x31323300 → "123\0" → "123"
  String rawBytesToString(int raw32) {
    final bytes = [
      (raw32 >> 24) & 0xFF,
      (raw32 >> 16) & 0xFF,
      (raw32 >> 8)  & 0xFF,
      raw32         & 0xFF,
    ];
    return String.fromCharCodes(bytes).split('\0').first;
  }
}
