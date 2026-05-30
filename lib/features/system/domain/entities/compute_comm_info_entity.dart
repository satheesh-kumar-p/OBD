import '../../enums/subsystem_status_enum.dart';

class ComputeCommInfoEntity {
  final SubsystemStatus uhfRadio;
  final SubsystemStatus compute;

  ComputeCommInfoEntity({
    required this.uhfRadio,
    required this.compute,
  });

  @override
  String toString() {
    return 'ComputeCommInfoEntity(uhf: $uhfRadio, compute: $compute)';
  }
}
