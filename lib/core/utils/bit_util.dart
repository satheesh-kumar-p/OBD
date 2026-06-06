import 'dart:typed_data';

/// Utility to extract bits from a CAN payload.
class BitUtil {
  /// Extracts a value from [data] starting at [startBit] with [length] bits.
  /// Logic: Big Endian - Bit 0 is MSB, Bit 7 is LSB.
  static int getBitsByLength(Uint8List data, int startBit, int length) {
    if (startBit < 0 || length < 0) {
      throw ArgumentError('startBit and length must be non-negative');
    }

    int value = 0;
    String bitString = '';
    for (int i = 0; i < length; i++) {
      int bitPos = startBit + i;
      int byteIdx = bitPos ~/ 8;
      // If Bit 0 is MSB, then bit 0 in a byte corresponds to bit 7 in standard shifting (0x80)
      int bitIdx = 7 - (bitPos % 8);

      if (byteIdx >= data.length) break;

      // Extract the bit (from MSB towards LSB)
      int bit = (data[byteIdx] >> bitIdx) & 0x01;
      bitString += bit.toString();
      
      // Since startBit is MSB, as i increases, significance decreases
      value |= (bit << (length - 1 - i));
    }
    return value;
  }

  static int getBitsByRange(Uint8List data, int startBit, int endBit) {
    if (endBit < startBit) throw ArgumentError('End bit cannot be less than Start bit!');

    int length = (endBit - startBit) + 1;
    return getBitsByLength(data, startBit, length);
  }

}
