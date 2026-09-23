import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../di/injection_container.dart';
import '../../features/system/system_providers.dart';
import '../../features/debug/di/debug_providers.dart';

/// The CoreController is responsible for keeping background services alive
/// without triggering unnecessary UI rebuilds at the application root.
class CoreController extends Notifier<void> {
  @override
  void build() {
    // These watches ensure the providers are initialized and stay alive
    // for the lifetime of the application.
    ref.watch(commConnectionProvider);
    ref.watch(systemScreenStateProvider);
    ref.watch(debugNotifierProvider);

    return;
  }
}

final coreControllerProvider = NotifierProvider<CoreController, void>(
  CoreController.new,
);
