import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:nextcountdown/themes/app_theme.dart';
import 'package:nextcountdown/routing/app_router.dart';

void main() {
  // Use path URL strategy for web
  usePathUrlStrategy();

  runApp(const ProviderScope(child: CountdownTimerApp()));
}

class CountdownTimerApp extends ConsumerWidget {
  const CountdownTimerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: '倒數計時器',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
