import 'dart:typed_data';

import '../../enums/can_enums.dart';

/// Configuration for the Waveshare USB-to-CAN adapter.
class CanConfig {
  final CanBaudRate baudRate;
  final bool useExtendedFrames;
  final int filterId;
  final int maskId;
  final CanMode mode;
  final bool autoRetransmit;

  const CanConfig({
    required this.baudRate,
    this.useExtendedFrames = false,
    this.filterId = 0,
    this.maskId = 0,
    this.mode = CanMode.normal,
    this.autoRetransmit = true,
  });

  /// Serializes the configuration into a 20-byte command packet.
  Uint8List toCommandPacket() {
    final packet = Uint8List(20);

    // Header
    packet[0] = 0xAA;
    packet[1] = 0x55;

    // Type: 0x12 for Variable Length Protocol Setting
    packet[2] = 0x12;

    packet[3] = baudRate.value;
    packet[4] = useExtendedFrames ? 0x02 : 0x01;

    // Filter ID (Big Endian as per wiki: "high byte first")
    final filterData = ByteData(4)..setUint32(0, filterId, Endian.big);
    packet.setRange(5, 9, filterData.buffer.asUint8List());

    // Mask/Block ID (Big Endian)
    final maskData = ByteData(4)..setUint32(0, maskId, Endian.big);
    packet.setRange(9, 13, maskData.buffer.asUint8List());

    packet[13] = mode.value;
    packet[14] = autoRetransmit ? 0x00 : 0x01;

    // Bytes 15-18 are backup (0x00)

    // Checksum (Low 8 bits of sum from byte 2 to 18)
    int sum = 0;
    for (int i = 2; i <= 18; i++) {
      sum += packet[i];
    }
    packet[19] = sum & 0xFF;

    return packet;
  }
}
