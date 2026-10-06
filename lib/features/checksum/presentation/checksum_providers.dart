import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scout_obd/features/checksum/domain/entities/checksum_status_entity.dart';
import 'package:scout_obd/features/checksum/presentation/application/checksum_status_controller.dart';
import 'package:scout_obd/features/checksum/di/checksum_data_providers.dart';

final checksumStatusControllerProvider = Provider.autoDispose<ChecksumStatusController>((ref) {
  final controller = ChecksumStatusController(
    selfInfoRepository: ref.watch(checksumSelfInfoRepositoryProvider),
    statusRepository: ref.watch(checksumStatusRepositoryProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

final checksumStatusUiStateProvider = Provider.autoDispose<List<ChecksumStatusEntity>>((ref) {
  final controller = ref.watch(checksumStatusControllerProvider);

  final subscription = controller.stateStream.listen((_) => ref.invalidateSelf());
  ref.onDispose(subscription.cancel);

  return controller.state;
});