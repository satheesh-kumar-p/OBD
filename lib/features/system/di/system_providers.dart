import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/system_controller.dart';
import '../presentation/state/system_screen_state.dart';

final systemControllerProvider = NotifierProvider<SystemController, SystemScreenState>(
  SystemController.new,
);

final systemScreenStateProvider = systemControllerProvider;
