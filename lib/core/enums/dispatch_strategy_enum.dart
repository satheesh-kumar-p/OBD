enum DispatchStrategy {
  /// Emit frames as soon as they arrive.
  passThrough,

  /// Emit only the latest frame at a fixed frequency.
  throttle,
}