import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/router_config.dart';
import 'package:recurseo/core/theme/app_theme.dart';
import 'package:recurseo/shared/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Asegurar inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // TODO: Inicializar Firebase si se usa
  // await Firebase.initializeApp();

  runApp(
    // ProviderScope es necesario para Riverpod
    ProviderScope(
      overrides: [
        // Proveer la instancia de SharedPreferences
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MainApp(),
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
