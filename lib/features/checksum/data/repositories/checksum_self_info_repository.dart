import '../../domain/entities/checksum_status_entity.dart';
import '../services/checksum_self_info_service.dart';

class ChecksumSelfInfoRepository {
  final ChecksumSelfInfoService _service;

  ChecksumSelfInfoRepository(this._service);

  ChecksumStatusEntity? _cached;
  Future<ChecksumStatusEntity?>? _loading;

  Future<ChecksumStatusEntity?> getSelfInfo() {
    // Already successfully loaded.
    if (_cached != null) {
      return Future.value(_cached);
    }

    // A request is already in progress.
    if (_loading != null) {
      return _loading!;
    }

    // Start a new request.
    final future = _loadSelfInfo();
    _loading = future;

    return future;
  }

  Future<ChecksumStatusEntity?> _loadSelfInfo() async {
    try {
      final info = await _service.fetchBuildInfo();

      final entity = ChecksumStatusEntity(
        appName: info.name,
        version: info.version,
        checksum: info.checksum,

      );

      _cached = entity;

      return entity;
    } finally {
      // Allow retry if loading failed.
      _loading = null;
    }
  }
}