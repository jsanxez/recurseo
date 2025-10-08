import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recurseo/core/config/router_config.dart';
import 'package:recurseo/core/theme/app_theme.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_providers.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  // Asegurar inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar timeago en español
  timeago.setLocaleMessages('es', timeago.EsMessages());

  // Inicializar SharedPreferences antes de iniciar la app
  final sharedPreferences = await SharedPreferences.getInstance();

  // TODO: Inicializar Firebase si se usa
  // await Firebase.initializeApp();

  runApp(
    // ProviderScope con override de SharedPreferences
    ProviderScope(
      overrides: [
        // Proveer la instancia inicializada de SharedPreferences
        sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
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
