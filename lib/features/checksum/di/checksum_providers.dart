/// DI barrel for the checksum feature, mirroring
/// `features/debug/di/debug_providers.dart`'s role: a single import point
/// for this feature's Riverpod providers, so consumers (like
/// `CoreController`) don't need to know the internal file layout under
/// `presentation/state/`.
library;

export '../presentation/state/checksum_status_notifier.dart'
    show ChecksumStatusNotifier, checksumStatusNotifierProvider;

// ChecksumStatusLogNotifier,
// checksumStatusLogNotifierProvider;

//it is the bridge file for the UI and the data layer

//When your ChecksumStatusScreen needs to watch the state, it imports checksum_providers.dart to access checksumStatusNotifierProvider cleanly without needing to know where the notifier is physically saved in your project directories
