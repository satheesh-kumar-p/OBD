import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/logger/logger.dart';
import '../data/mappers/checksum_status_mapper.dart';
import '../data/repositories/checksum_self_info_repository_impl.dart';
import '../data/repositories/checksum_status_repository_impl.dart';
import '../domain/repositories/i_checksum_self_info_repository.dart';
import '../domain/repositories/i_checksum_status_repository.dart';

final checksumLoggerProvider = Provider<Logger>((ref) => Logger('CHECKSUM'));

final checksumSelfInfoRepositoryProvider =
    Provider<IChecksumSelfInfoRepository>(
      (ref) => ChecksumSelfInfoRepositoryImpl(),
    );

final checksumStatusRepositoryProvider = Provider<IChecksumStatusRepository>((
  ref,
) {
  final logger = ref.read(checksumLoggerProvider);
  final canManager = ref.watch(commManagerProvider);
  final mapper = ChecksumStatusMapper();
  return ChecksumStatusRepositoryImpl(
    canManager: canManager,
    mapper: mapper,
    logger: logger,
  );
});
