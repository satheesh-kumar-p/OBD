import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/di/injection_container.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/features/compute/application/use_cases/send_software_version_usecase.dart';
import 'package:scout_obd/features/compute/data/models/ugv_component_version_model.dart';
import 'package:scout_obd/features/compute/data/repositories/ugv_component_version_repository_impl.dart';
import 'package:scout_obd/features/compute/domain/repositories/ugv_component_version_repository.dart';

final ugvVersionRepoProvider = Provider<UgvComponentVersionRepository>((ref) {
  final commManager = ref.watch(commManagerProvider);
  final logger = Logger('UGV_VERSION_REPO');

  return UgvComponentVersionRespositoryImpl(
    commManager: commManager,
    logger: logger,
  );
});

final sendUgvVersionUseCaseProvider = Provider<SendUgvVersionOnHeartbeatUseCase>((ref) {
  return SendUgvVersionOnHeartbeatUseCase(ref.watch(ugvVersionRepoProvider));
});

List<int> hexStringToBytes(String hex) {
  final bytes = <int>[];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return bytes;
}

final ugvVersionProvider = FutureProvider<void>((ref) {
  final useCase = ref.watch(sendUgvVersionUseCaseProvider);

  final versionModel = UgvComponentVersionModel(
    softwareVersion: 0x01000204,
    checksum: hexStringToBytes('6a7f3ae72d88f3cb5cf8101f2797ea28b31fcf98a5012c4d10231e8a9536063b'),
    targetSystem: AppConstants.ugvSystemId,
    targetComponent: AppConstants.ugvComponentId,
  );
  return useCase.sendMessage(
    softwareVersion: versionModel.softwareVersion,
    checksum: versionModel.checksum,
    targetSystem: versionModel.targetSystem,
    targetComponent: versionModel.targetComponent,
  );
});