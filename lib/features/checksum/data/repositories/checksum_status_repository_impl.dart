import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/checksum_status_entity.dart';
import '../../domain/repositories/i_checksum_status_repository.dart';
import '../mappers/checksum_status_mapper.dart';

/// Data layer: pulls raw bytes from the core comm layer, decodes them
/// via the mapper, never lets a decode failure crash the stream.
class ChecksumStatusRepositoryImpl implements IChecksumStatusRepository {
  final CommManager _canManager;
  final ChecksumStatusMapper _mapper;
  final Logger _logger;

  ChecksumStatusRepositoryImpl({
    required CommManager canManager,
    required ChecksumStatusMapper mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  @override
  Stream<List<ChecksumStatusEntity>> watchStatuses() {
    return _canManager.checksumDataStream.map((data) {
      try {
        return _mapper.fromBytes(data);
      } catch (e, st) {
        _logger.error('Failed to decode checksum packet', error: e, stack: st);
        return <ChecksumStatusEntity>[];
      }
    });
  }
}