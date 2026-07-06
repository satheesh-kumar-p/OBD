import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';

/// Provides the current system time formatted as a string, updating every second.
final systemTimeProvider = Provider<String>((ref) {
  ref.watch(clockTickerProvider);
  final now = DateTime.now();

  return '${now.day.toString().padLeft(2, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';
});
