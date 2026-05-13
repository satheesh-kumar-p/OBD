import 'package:mavlink_nrt/mavlink.dart';

/// Contract for one mavlink connection (One transport + one parser)
/// Each physical link gets its own implementation

abstract class MavlinkService {
  /// Getter method to expose parsed [MavlinkFrame]
  Stream<MavlinkFrame> get frameStream;

  /// Emits true on connect, false on disconnect / error
  Stream<bool> get connectionStream;

  bool get isConnected;

  Future<void> connect();
  Future<void> disconnect();

  /// Method to send Mavlink formatted messages to the already connected transport
  /// Ensure transport is already connected before sending a messaage.
  /// Other services use this method to send the mavlink messages

  Future<void> send(MavlinkMessage message);
}