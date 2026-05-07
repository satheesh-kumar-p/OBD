abstract class UgvVersionRepository {
  Future<void> sendVersionOnFirstHeartbeat({
    required int softwareVersion,
    required List<int> checksum,
    required int targetSystem,
    required int targetComponent,
  });
}
