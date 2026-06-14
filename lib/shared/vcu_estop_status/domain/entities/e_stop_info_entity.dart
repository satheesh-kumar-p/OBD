import '../../enums/e_stop_status_enum.dart';

class EStopInfoEntity {
  final EStopStatus status;

  EStopInfoEntity({required this.status});

  @override
  String toString() {
    return 'EStopInfo(status: $status)';
  }
}
