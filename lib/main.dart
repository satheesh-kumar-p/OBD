import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart';
import 'features/dashboard/di/battery_info_providers.dart';
import 'features/dashboard/di/mode_info_providers.dart';
import 'features/dashboard/presentation/screens/dashboard.dart';
import 'features/dashboard/presentation/widgets/app_background.dart';
import 'features/system/di/system_info_providers.dart';
import 'shared/di/global_time_info_providers.dart';
import 'features/debug/di/debug_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    const ProviderScope(
        child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          home: const _AppBootstrapper(),
        );
      },
    );
  }
}

class _AppBootstrapper extends ConsumerWidget {
  const _AppBootstrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start background services immediately
    ref.watch(canConnectionProvider);
    ref.watch(systemScreenStateProvider);
    ref.watch(modeInfoProvider);
    ref.watch(batteryInfoProvider);
    ref.watch(globalTimeProvider);
    ref.watch(debugNotifierProvider);

    return const Dashboard();
  }
}
