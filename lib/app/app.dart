import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../features/settings/presentation/settings_controller.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class EucharystkiApp extends ConsumerWidget {
  const EucharystkiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    WakelockPlus.toggle(enable: settings.keepScreenOn);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Малітоўнік Эўхарыстак',
      theme: AppTheme.light(settings.fontFamily),
      darkTheme: AppTheme.dark(settings.fontFamily),
      themeMode: settings.themeMode,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('be'),
    );
  }
}
