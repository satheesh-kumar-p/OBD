import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';
import '../../shared/vcu_power_status/di/battery_info_providers.dart';
import '../../shared/vcu_status/vcu_status_providers.dart';
import 'presentation/state/common_screen_state.dart';

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

final commonScreenStateProvider = NotifierProvider<CommonScreenStateNotifier, CommonScreenState>(
  CommonScreenStateNotifier.new,
);

class CommonScreenStateNotifier extends Notifier<CommonScreenState> {
  @override
  CommonScreenState build() {
    final vcuStatus = ref.watch(vcuStatusProvider).value;
    final computeInfo = ref.watch(compSubsystemInfoProvider).value;
    final batteryInfo = ref.watch(batteryInfoProvider).value;
    final systemTime = ref.watch(systemTimeProvider);

    return CommonScreenState(
      vcuStatus: vcuStatus,
      computeCommInfo: computeInfo,
      batteryInfo: batteryInfo,
      systemTime: systemTime,
    );
  }
}
