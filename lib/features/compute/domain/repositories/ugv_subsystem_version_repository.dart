import '../../data/models/ugv_subsystem_version_model.dart';

abstract class UgvSubsystemVersionRepository {
  Future<List<UgvSubsystemVersionModel>> requestSubsystemVersions();
}
