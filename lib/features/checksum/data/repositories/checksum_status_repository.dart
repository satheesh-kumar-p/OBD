import '../../../../core/comm/comm_manager.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/entities/checksum_status_entity.dart';
import '../mappers/checksum_status_mapper.dart';

class ChecksumStatusRepository {
  final CommManager _canManager;
  final ChecksumStatusMapper _mapper;
  final Logger _logger;

  ChecksumStatusRepository({
    required CommManager canManager,
    required ChecksumStatusMapper mapper,
    required Logger logger,
  })  : _canManager = canManager,
        _mapper = mapper,
        _logger = logger;

  Stream<List<ChecksumStatusEntity>> watchDecodedStatuses() {
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