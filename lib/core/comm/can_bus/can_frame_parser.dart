import 'dart:async';
import 'dart:typed_data';
import '../../enums/can_enums.dart';
import 'can_frame.dart';

class CanFrameParser {
  final List<int> _rxBuffer = [];
  final StreamController<CanFrame> _framesController =
  StreamController<CanFrame>.broadcast();

  Stream<CanFrame> get frames => _framesController.stream;

  void feed(Uint8List rawData) {
    _rxBuffer.addAll(rawData);

    while (_rxBuffer.isNotEmpty) {
      final frame = _tryParseFrame();
      if (frame == null) break;
      _framesController.add(frame);
    }
  }

  CanFrame? _tryParseFrame() {
    // 1. Find Header (0xAA)
    // If the first byte isn't 0xAA, skip until we find one or buffer is empty.
    while (_rxBuffer.isNotEmpty && _rxBuffer[0] != 0xAA) {
      _rxBuffer.removeAt(0);
    }

    if (_rxBuffer.isEmpty) return null;

    // 2. Need at least Header + Control byte
    if (_rxBuffer.length < 2) return null;

    final int control = _rxBuffer[1];
    
    // bit5: 0 - standard, 1 - extended
    final bool isExtended = (control & 0x20) != 0;
    // bit4: 0 - data frame, 1 - remote frame
    final bool isRemote = (control & 0x10) != 0;
    // bit0~3: length
    final int dlc = control & 0x0F;
    
    final int idBytes = isExtended ? 4 : 2;
    final int totalFrameLen = 2 + idBytes + dlc + 1;

    // 3. Wait for full frame
    if (_rxBuffer.length < totalFrameLen) return null;

    // 4. Verify Footer (0x55)
    if (_rxBuffer[totalFrameLen - 1] != 0x55) {
      // Invalid frame, discard the header and keep searching
      _rxBuffer.removeAt(0);
      return null;
    }

    // 5. Extract ID
    final idData = Uint8List.fromList(_rxBuffer.sublist(2, 2 + idBytes));
    final int messageId = isExtended
        ? ByteData.view(idData.buffer).getUint32(0, Endian.little)
        : ByteData.view(idData.buffer).getUint16(0, Endian.little);

    // 6. Extract Payload
    final Uint8List payload = Uint8List.fromList(
      _rxBuffer.sublist(2 + idBytes, 2 + idBytes + dlc),
    );

    final frame = CanFrame(
      id: messageId,
      idType: isExtended ? CanIdType.extended : CanIdType.standard,
      format: isRemote ? CanFrameFormat.remote : CanFrameFormat.data,
      data: payload,
    );

    // 7. Clear processed bytes
    _rxBuffer.removeRange(0, totalFrameLen);

    return frame;
  }

  /// Serializes a CanFrame into the Waveshare Variable Length format for transmission.
  static Uint8List serialize(CanFrame frame) {
    final int idBytesCount = frame.idType == CanIdType.extended ? 4 : 2;
    final int totalLen = 2 + idBytesCount + frame.dlc + 1;
    final buffer = Uint8List(totalLen);

    buffer[0] = 0xAA; // Header

    // Control Byte
    int control = 0xC0;
    if (frame.idType == CanIdType.extended) control |= 0x20;
    if (frame.format == CanFrameFormat.remote) control |= 0x10;
    control |= (frame.dlc & 0x0F);
    buffer[1] = control;

    // ID (Little Endian)
    final idData = ByteData(idBytesCount);
    if (frame.idType == CanIdType.extended) {
      idData.setUint32(0, frame.id, Endian.little);
    } else {
      idData.setUint16(0, frame.id, Endian.little);
    }
    buffer.setRange(2, 2 + idBytesCount, idData.buffer.asUint8List());

    // Payload
    buffer.setRange(2 + idBytesCount, 2 + idBytesCount + frame.dlc, frame.data);

    // Footer
    buffer[totalLen - 1] = 0x55;

    return buffer;
  }

  void dispose() {
    _rxBuffer.clear();
    _framesController.close();
  }
}
