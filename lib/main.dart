import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/features/dashboard/di/battery_info_providers.dart';
import 'package:scout_obd/features/dashboard/di/mode_info_providers.dart';
import 'package:scout_obd/features/system/di/system_info_providers.dart';

import 'core/di/injection_container.dart';
import 'features/dashboard/presentation/screens/dashboard.dart';
import 'features/dashboard/presentation/widgets/app_background.dart';
import 'shared/di/global_time_info_providers.dart';
import 'shared/di/mode_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    const ProviderScope(
        child: MyApp()
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the connection process.
    final connectionState = ref.watch(canConnectionProvider);

    return ScreenUtilInit(
      designSize: const Size(1280, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: AppConstants.useMockBackends,
          title: 'Scout Display',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.black,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightBlueAccent,
              brightness: Brightness.dark,
            ),
          ),
          builder: (context, child) {
            return AppBackground(child: child ?? const SizedBox.shrink());
          },
          // 2. Handle connection lifecycle in the UI
          home: connectionState.when(
            data: (_) {
              ref.watch(systemScreenStateProvider);
              ref.watch(modeInfoProvider);
              ref.watch(batteryInfoProvider);
              ref.watch(globalTimeProvider);
              return const Dashboard();
            },
            loading: () => const _ConnectionLoadingScreen(message: 'Initializing Transport...'),
            error: (err, stack) => _ConnectionErrorScreen(
              error: err,
              onRetry: () => ref.invalidate(canConnectionProvider),
            ),
          ),
        );
      },
    );
  }
}

class _ConnectionLoadingScreen extends StatelessWidget {
  const _ConnectionLoadingScreen({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF2FD0FF)),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, letterSpacing: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionErrorScreen extends StatelessWidget {
  const _ConnectionErrorScreen({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 64),
              const SizedBox(height: 16),
              const Text(
                'CONNECTION FAILED',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(error.toString(), style: const TextStyle(color: Colors.white54), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2FD0FF)),
                child: const Text('RETRY', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
