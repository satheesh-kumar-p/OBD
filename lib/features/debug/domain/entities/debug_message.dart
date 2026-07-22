import 'dart:typed_data';

class DebugMessage {
  final DateTime timestamp;
  final int id;
  final Uint8List rawData;
  final String? decodedData;

  DebugMessage({
    required this.timestamp,
    required this.id,
    required this.rawData,
    this.decodedData,
  });

  String get hexId => '0x${id.toRadixString(16).toUpperCase().padLeft(3, '0')}';
  
  String get rawDataHex => rawData.map((b) => b.toRadixString(16).toUpperCase().padLeft(2, '0')).join(' ');
}
