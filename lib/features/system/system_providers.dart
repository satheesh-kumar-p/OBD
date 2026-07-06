import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/comp_subsystem_state/comp_subsystem_state_providers.dart';
import '../../shared/vcu_status/vcu_status_providers.dart';
import '../../shared/vcu_subsystem_state/di/system_info_providers.dart';
import 'presentation/state/system_screen_state.dart';

final systemScreenStateProvider = NotifierProvider<SystemScreenNotifier, SystemScreenState>(
  SystemScreenNotifier.new,
);

class SystemScreenNotifier extends Notifier<SystemScreenState> {
  @override
  SystemScreenState build() {
    final systemInfo = ref.watch(systemInfoProvider).value;
    final computeInfo = ref.watch(compSubsystemInfoProvider).value;
    final vcuStatus = ref.watch(vcuStatusProvider).value;

    return SystemScreenState(
      systemInfo: systemInfo,
      computeCommInfo: computeInfo,
      vcuStatus: vcuStatus,
    );
  }
}
