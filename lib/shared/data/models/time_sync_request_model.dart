class TimeSyncRequestModel {
  final int _tc1Us = 0; // Responding component timestamp (UGV-Main Compute)
  final int _ts1Us; // Syncing component timestamp (Clients: OBD, GCS, Hand controller)

  TimeSyncRequestModel({required int ts1}) : _ts1Us = ts1;

  int get tc1 => _tc1Us;

  int get ts1 => _ts1Us;
}
