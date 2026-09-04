import 'dart:typed_data';

/// One raw UDP datagram received on the checksum port, before any JSON
/// decoding. Produced by [CommManager]'s checksum transport; consumed by
/// [ChecksumJsonParser] / [ChecksumStatusMapper] downstream.
class ChecksumPacket {
  final DateTime timestamp;
  final Uint8List data;

  ChecksumPacket({
    required this.timestamp,
    required this.data,
  });
}