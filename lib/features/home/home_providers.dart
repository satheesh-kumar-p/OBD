import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the currently selected tab in the home layout.
final homeIndexProvider = NotifierProvider<HomeIndexNotifier, int>(HomeIndexNotifier.new);

class HomeIndexNotifier extends Notifier<int> {
  @override
  int build() => 0; // Initial state

  /// Method to update the index from the UI
  void setIndex(int newIndex) {
    state = newIndex;
  }
}