import 'dart:typed_data';

/// Utility to extract bits from a CAN payload.
class BitUtil {
  /// Extracts a value from [data] starting at [startBit] with [length] bits.
  static int getBitsByLength(Uint8List data, int startBit, int length) {
    if (startBit < 0 || length < 0) {
      throw ArgumentError('startBit and length must be non-negative');
    }

    int value = 0;
    for (int i = 0; i < length; i++) {
      int bitPos = startBit + i;
      int byteIdx = bitPos ~/ 8;
      int bitIdx = bitPos % 8;

      if (byteIdx >= data.length) break;

      int bit = (data[byteIdx] >> bitIdx) & 0x01;
      value |= (bit << i);
    }
    return value;
  }

  static int getBitsByRange(Uint8List data, int startBit, int endBit) {
    if (endBit < startBit) throw ArgumentError('End bit cannot be less than Start bit!');

    int length = (endBit - startBit) + 1;
    return getBitsByLength(data, startBit, length);
  }

}
