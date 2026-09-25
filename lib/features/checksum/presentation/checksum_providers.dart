import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ CORRECT
import 'package:scout_obd/features/checksum/domain/entities/checksum_status_entity.dart';
import 'package:scout_obd/features/checksum/presentation/application/checksum_status_controller.dart';
import 'package:scout_obd/features/checksum/di/checksum_data_providers.dart'; // Adjust path based on where checksum_data_providers.dart actually lives

//constructing the controller
final checksumStatusControllerProvider = Provider.autoDispose<ChecksumStatusController>((ref) {
  final controller = ChecksumStatusController(
    selfInfoRepository: ref.watch(checksumSelfInfoRepositoryProvider),
    statusRepository: ref.watch(checksumStatusRepositoryProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

final checksumStatusUiStateProvider =
    StreamProvider.autoDispose<List<ChecksumStatusEntity>>(
  (ref) => ref.watch(checksumStatusControllerProvider).stateStream,
);