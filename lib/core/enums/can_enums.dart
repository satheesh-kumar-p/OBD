/// CAN baud rate options supported by the Waveshare adapter.
enum CanBaudRate {
  bps1M(0x01),
  bps800k(0x02),
  bps500k(0x03),
  bps400k(0x04),
  bps250k(0x05),
  bps200k(0x06),
  bps125k(0x07),
  bps100k(0x08),
  bps50k(0x09),
  bps20k(0x0a),
  bps10k(0x0b),
  bps5k(0x0c);

  final int value;
  const CanBaudRate(this.value);
}

/// CAN operational modes.
enum CanMode {
  normal(0x00),
  silent(0x01),
  loopback(0x02),
  loopbackSilent(0x03);

  final int value;
  const CanMode(this.value);
}

/// The type of identifier used in the CAN frame.
enum CanIdType {
  /// 11-bit identifier.
  standard,
  /// 29-bit identifier.
  extended,
}

/// The format of the CAN frame.
enum CanFrameFormat {
  /// Contains data payload.
  data,
  /// Remote Transmission Request.
  remote,
}