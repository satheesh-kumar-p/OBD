enum FirmwareVersionType {
  dev,      // 0
  alpha,    // 64
  beta,     // 128
  rc,       // 192
  official, // 255
}

extension FirmwareVersionTypeExt on FirmwareVersionType {
  int toInt() {
    switch (this) {
      case FirmwareVersionType.dev:      return 0;
      case FirmwareVersionType.alpha:    return 64;
      case FirmwareVersionType.beta:     return 128;
      case FirmwareVersionType.rc:       return 192;
      case FirmwareVersionType.official: return 255;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────
// FirmwareVersion32 – compact uint32_t → X.Y.Z + type
// ─────────────────────────────────────────────────────────────────────

class FirmwareVersion32 {
  final int major;
  final int minor;
  final int patch;
  final FirmwareVersionType type;

  const FirmwareVersion32(this.major, this.minor, this.patch, this.type);

  int toUint32() {
    return ((major & 0xFF) << 24) |
    ((minor & 0xFF) << 16) |
    ((patch & 0xFF) << 8) |
    (type.toInt() & 0xFF);
  }

  static FirmwareVersion32 fromUint32(int v32) {
    final major = (v32 >> 24) & 0xFF;
    final minor = (v32 >> 16) & 0xFF;
    final patch = (v32 >> 8) & 0xFF;
    final rawType = v32 & 0xFF;

    final type = FirmwareVersionType.values.firstWhere(
          (t) => t.toInt() == rawType,
      orElse: () => FirmwareVersionType.dev,
    );

    return FirmwareVersion32(major, minor, patch, type);
  }

  @override
  String toString() {
    final postfix = <int, String>{
      0:   'dev',
      64:  'alpha',
      128: 'beta',
      192: 'rc',
      255: 'official',
    }[type.toInt()] ?? 'custom';

    return '$major.$minor.$patch-$postfix';
  }
}