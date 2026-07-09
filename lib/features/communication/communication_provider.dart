import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'communication_state.dart';

final radioStatusStreamProvider = StreamProvider<dynamic>((ref) async* {
  yield null;
});

final radioServiceProvider = StreamProvider<dynamic>((ref) async* {
  yield null;
});

final communicationStateProvider = Provider<CommunicationState>((ref) {
  final radioStatusAsync = ref.watch(radioStatusStreamProvider);

  return radioStatusAsync.when(
    data: (entity) {
      // 1. Check if the incoming data is null
      if (entity == null) {
        return CommunicationState.initial();
      }

      // 2. If it is not null, safely pass it to your factory
      return CommunicationState.fromEntity(entity);
    },
    loading: () => CommunicationState.initial(),
    error: (_, __) => CommunicationState.initial(),
  );
});