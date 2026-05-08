import '../../data/models/ugv_subsystem_version_model.dart';
import '../../domain/repositories/ugv_subsystem_version_repository.dart';

class RequestUgvVersionsUseCase {
  final UgvSubsystemVersionRepository _repository;

  RequestUgvVersionsUseCase(this._repository);

  Future<List<UgvSubsystemVersionModel>> call() {
    return _repository.requestSubsystemVersions();
  }
}
