import 'dart:async';
import 'can_frame.dart';
import 'can_config.dart';

/// Abstract interface for CAN communication.
abstract class CanService {
  /// Stream of successfully parsed CAN frames.
  Stream<CanFrame> get frameStream;

  /// Stream of connection status changes.
  Stream<bool> get connectionStream;

  /// Whether the service is currently connected to the hardware.
  bool get isConnected;

  /// Connects to the CAN hardware.
  Future<void> connect(
    String portName, {
    int baudRate = 2000000,
    required CanConfig config,
  });

  /// Disconnects from the hardware.
  Future<void> disconnect();

  /// Sends a [CanFrame] to the bus.
  Future<void> send(CanFrame frame);

  /// Releases resources.
  void dispose();
}
