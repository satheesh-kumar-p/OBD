import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sensor_state.dart';

final sensorStateProvider = Provider<SensorScreenState>((ref) {
  return SensorScreenState(
    tiles: [
      _mockEthernetSwitch(),
      _mockGnss(),
      _mockCameras(),
      _mockImu(),
      _mock2DLidar(),
      _mock3DLidar(),
    ],
  );
});

SensorTileState _mockEthernetSwitch() {
  return SensorTileState(
    title: 'Ethernet Switch',
    items: [
      SensorItemState.fromPower(label: 'Power Status', power: SensorPower.off),
      SensorItemState.fromHealth(label: 'Overall Health', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'GNSS Ping Fault', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'L Band Radio Ping Fault', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: '2D Lidar Ping Fault', health: SensorHealth.faulty),
      SensorItemState.fromHealth(label: '3D Lidar Ping Fault', health: SensorHealth.unknown),
      SensorItemState.fromHealth(label: 'Secondary Compute Ping Fault', health: SensorHealth.healthy),
    ],
  );
}

SensorTileState _mockGnss() {
  return SensorTileState(
    title: 'GNSS',
    items: [
      SensorItemState.fromPower(label: 'Power Status', power: SensorPower.on),
      // Using the specialized factory for GNSS Overall Health
      SensorItemState.fromGnssHealth(label: 'Overall Health', health: GnssHealth.degraded),
      SensorItemState.fromHealth(label: 'Position Validity Error Fault', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Fix Quality Fault', health: SensorHealth.unknown),
      SensorItemState.fromHealth(label: 'Fix Dimension Fault', health: SensorHealth.faulty),
      SensorItemState.fromHealth(label: 'Satellite Fault', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'HDOP Fault', health: SensorHealth.faulty),
      SensorItemState.fromHealth(label: 'Heading Validity Error Fault', health: SensorHealth.healthy),
    ],
  );
}

SensorTileState _mockImu() {
  return SensorTileState(
    title: 'IMU',
    items: [
      SensorItemState.fromPower(label: 'Power Status', power: SensorPower.on),
      SensorItemState.fromHealth(label: 'Overall Health', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Communication Fault', health: SensorHealth.faulty),
      SensorItemState.fromHealth(label: 'Data Integrity Fault', health: SensorHealth.unknown),
    ],
  );
}

SensorTileState _mock2DLidar() {
  return SensorTileState(
    title: '2D Lidar',
    items: [
      SensorItemState.fromPower(label: 'Power Status', power: SensorPower.on),
      SensorItemState.fromHealth(label: 'Overall Health', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Communication Fault', health: SensorHealth.faulty),
      SensorItemState.fromHealth(label: 'Data Integrity Fault', health: SensorHealth.unknown),
    ],
  );
}

SensorTileState _mock3DLidar() {
  return SensorTileState(
    title: '3D Lidar',
    items: [
      SensorItemState.fromPower(label: 'Power Status', power: SensorPower.off),
      SensorItemState.fromHealth(label: 'Overall Health', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Communication Fault', health: SensorHealth.faulty),
      SensorItemState.fromHealth(label: 'Data Integrity Fault', health: SensorHealth.unknown),
    ],
  );
}

SensorTileState _mockCameras() {
  return SensorTileState(
    title: 'Cameras',
    items: [
      SensorItemState.fromHealth(label: 'Front-Centre', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Front-Left', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Front-Right', health: SensorHealth.faulty),
      SensorItemState.fromHealth(label: 'Side-Left', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Side-Right', health: SensorHealth.healthy),
      SensorItemState.fromHealth(label: 'Rear', health: SensorHealth.unknown),
    ],
  );
}
