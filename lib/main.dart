import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/router_config.dart';
import 'package:recurseo/core/theme/app_theme.dart';

void main() {
  // Asegurar inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Inicializar Firebase si se usa
  // await Firebase.initializeApp();

  runApp(
    // ProviderScope es necesario para Riverpod
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Recurseo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
