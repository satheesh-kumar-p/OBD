import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/application/core_controller.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/widgets/app_background.dart';

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
      ensureScreenSize: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
    ref.watch(coreControllerProvider);

    return const HomeScreen();
  }
}
