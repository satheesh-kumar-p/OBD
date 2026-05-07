import 'package:scout_obd/features/compute/domain/entities/ugv_component_version_entity.dart';

class UgvComponentVersionModel {
  final int softwareVersion;

  final List<int> checksum;

  final int targetSystem;

  final int targetComponent;

  UgvComponentVersionModel({
    required this.softwareVersion,
    required this.checksum,
    required this.targetSystem,
    required this.targetComponent,
  });

  UgvComponentVersionEntity toEntity() {

    final major = (softwareVersion >> 24) & 0xFF;    // First byte (MSB)
    final minor = (softwareVersion >> 16) & 0xFF;    // Second byte
    final patch = (softwareVersion >> 8) & 0xFF;     // Third byte

    // Last byte becomes firmwareType
    final firmwareType = softwareVersion & 0xFF;

    return UgvComponentVersionEntity(
      major: major,
      minor: minor,
      patch: patch,
      firmwareType: firmwareType,
    );

  }
}