import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/checksum_status_mapper.dart';
import '../data/repositories/checksum_status_repository.dart';
import '../data/repositories/checksum_self_info_repository.dart';
import '../data/services/checksum_self_info_service.dart';
import '../domain/entities/checksum_status_entity.dart';

final checksumLoggerProvider = Provider<Logger>((ref) => Logger('CHECKSUM'));

final checksumSelfInfoProvider = FutureProvider<ChecksumStatusEntity?>(
  (ref) => ChecksumSelfInfoRepository(
    ChecksumSelfInfoService(),
  ).getSelfInfo(),
);

final checksumStatusRepositoryProvider = Provider<ChecksumStatusRepository>(
  (ref) {
    return ChecksumStatusRepository(
      canManager: ref.watch(commManagerProvider),
      mapper: ChecksumStatusMapper(),
      logger: ref.read(checksumLoggerProvider),
    );
  },
);

final checksumStatusStreamProvider = StreamProvider<List<ChecksumStatusEntity>>(
  (ref) {
    return ref.watch(checksumStatusRepositoryProvider).watchDecodedStatuses();
  },
);