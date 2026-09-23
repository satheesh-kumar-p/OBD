import 'dart:async';
import 'dart:typed_data';
import '../../enums/can_enums.dart';
import 'can_frame.dart';

class CanFrameParser {
  final List<int> _rxBuffer = [];
  final StreamController<CanFrame> _framesController =
      StreamController<CanFrame>.broadcast();
  final StreamController<Uint8List> _checksumController =
      StreamController<Uint8List>.broadcast();

  Stream<CanFrame> get frames => _framesController.stream;
  Stream<Uint8List> get checksumData => _checksumController.stream;

  void _emitchecksum(List<int> data) {
    if (data.isNotEmpty && !_checksumController.isClosed) {
      _checksumController.add(Uint8List.fromList(data));
    }
  }

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
    final checksum = <int>[];
    while (_rxBuffer.isNotEmpty && _rxBuffer[0] != 0xAA) {
      checksum.add(_rxBuffer.removeAt(0));
    }
    _emitchecksum(checksum);

    if (_rxBuffer.isEmpty) return null;

    // 2. Need at least Header + Control byte
    if (_rxBuffer.length < 2) return null;

    final int control = _rxBuffer[1];

    // bit7~6: Fixed to 1 for Variable Length protocol
    if ((control & 0xC0) != 0xC0) {
      // Not a valid control byte for this protocol, discard header
      final header = _rxBuffer.removeAt(0);
      _emitchecksum([header]);
      return null;
    }

    // bit0~3: length (Standard CAN allows 0-8 bytes)
    final int dlc = control & 0x0F;
    if (dlc > 8) {
      // Invalid length code, discard header and keep searching
      final header = _rxBuffer.removeAt(0);
      _emitchecksum([header]);
      return null;
    }

    // bit5: 0 - standard, 1 - extended
    final bool isExtended = (control & 0x20) != 0;
    // bit4: 0 - data frame, 1 - remote frame
    final bool isRemote = (control & 0x10) != 0;

    final int idBytes = isExtended ? 4 : 2;
    final int totalFrameLen = 2 + idBytes + dlc + 1;

    // 3. Wait for full frame
    if (_rxBuffer.length < totalFrameLen) return null;

    // 4. Verify Footer (0x55)
    if (_rxBuffer[totalFrameLen - 1] != 0x55) {
      // Invalid frame, discard the header and keep searching
      final header = _rxBuffer.removeAt(0);
      _emitchecksum([header]);
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
    _checksumController.close();
  }
}
