import 'package:scout_obd/features/compute/domain/repositories/ugv_component_version_repository.dart';

class SendUgvVersionOnHeartbeatUseCase {
  final UgvVersionRepository repository;

  const SendUgvVersionOnHeartbeatUseCase(this.repository);

  Future<void> sendMessage({
    required int softwareVersion,
    required List<int> checksum,
    required int targetSystem,
    required int targetComponent,
  }) async {
    await repository.sendVersionOnFirstHeartbeat(
      softwareVersion: softwareVersion,
      checksum: checksum,
      targetSystem: targetSystem,
      targetComponent: targetComponent,
    );
  }
}