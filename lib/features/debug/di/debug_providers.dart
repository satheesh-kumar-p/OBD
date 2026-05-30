import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/debug_notifier.dart';

final debugNotifierProvider = NotifierProvider<DebugNotifier, DebugState>(DebugNotifier.new);
