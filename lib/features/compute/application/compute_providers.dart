import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'compute_state.dart';

final computeStateProvider = Provider<ComputeScreenState>((ref) {
  return ComputeScreenState(
    tiles: [
      _mockMainCompute(),
      _mockSecondaryCompute(),
      _mockVcu(),
    ],
  );
});

ComputeTileState _mockMainCompute() {
  return ComputeTileState(
    title: 'Main Compute',
    items: [
      ComputeItemState.fromPower(label: 'Power Status', power: JetsonPower.on),
      ComputeItemState.fromHealth(label: 'Overall Health', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Jetson Heartbeat', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Temperature Fault', health: ComputeHealth.faulty),
      ComputeItemState.fromHealth(label: 'Voltage Fault', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'CPU Load Fault', health: ComputeHealth.unknown), // Unknown
      ComputeItemState.fromHealth(label: 'GPU Load Fault', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Memory Fault', health: null), // Null/Unknown
      ComputeItemState.fromHealth(label: 'Storage Fault', health: ComputeHealth.healthy),
    ],
  );
}

ComputeTileState _mockSecondaryCompute() {
  return ComputeTileState(
    title: 'Secondary Compute',
    items: [
      ComputeItemState.fromHealth(label: 'Overall Health', health: ComputeHealth.faulty),
      ComputeItemState.fromHealth(label: 'CPU Load Fault', health: ComputeHealth.faulty),
      ComputeItemState.fromHealth(label: 'Memory Fault', health: ComputeHealth.unknown), // Unknown
      ComputeItemState.fromHealth(label: 'Storage Fault', health: ComputeHealth.healthy),
    ],
  );
}

ComputeTileState _mockVcu() {
  return ComputeTileState(
    title: 'VCU',
    items: [
      ComputeItemState.fromHealth(label: 'Overall Health', health: ComputeHealth.unknown), // Unknown
      ComputeItemState.fromHealth(label: 'Supply Voltage Fault', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'MCU Watchdog Fault', health: ComputeHealth.faulty),
      ComputeItemState.fromHealth(label: 'CPU Overload', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'RAM Fault', health: null), // Null/Unknown
      ComputeItemState.fromHealth(label: 'Flash CRC Failure', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'FCC Active', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Safety SBC Fault', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'CAN A Bus-off', health: ComputeHealth.unknown),
      ComputeItemState.fromHealth(label: 'CAN B Bus-off', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'CAN C Bus-off', health: ComputeHealth.faulty),
      ComputeItemState.fromHealth(label: 'Internal Temperature Fault', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Output Driver Fault', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Boot Failure', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Analog Interface Fault', health: ComputeHealth.healthy),
      ComputeItemState.fromHealth(label: 'Discrete Interface Fault', health: ComputeHealth.healthy),
    ],
  );
}
