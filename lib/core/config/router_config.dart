import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/auth/presentation/screens/login_screen.dart';
import 'package:recurseo/features/auth/presentation/screens/register_screen.dart';
import 'package:recurseo/features/auth/presentation/screens/splash_screen.dart';
import 'package:recurseo/features/auth/presentation/screens/welcome_screen.dart';
import 'package:recurseo/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:recurseo/features/profile/presentation/screens/provider_public_profile_screen.dart';
import 'package:recurseo/features/profile/presentation/screens/settings_screen.dart';
import 'package:recurseo/features/jobs/presentation/screens/home_screen.dart';

/// Configuración de rutas de la aplicación
class AppRouterConfig {
  AppRouterConfig._();

  /// Crear router con acceso a Ref para guards
  static GoRouter router(Ref ref) => GoRouter(
        initialLocation: '/splash',
        debugLogDiagnostics: true,
        refreshListenable: GoRouterRefreshStream(ref),
        routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Welcome
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Home (pantalla principal con bottom nav)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Autenticación
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Perfil
      GoRoute(
        path: '/profile/edit',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/provider/:id',
        name: 'provider-profile',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProviderPublicProfileScreen(providerId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // TODO: Agregar rutas de servicios
      // GoRoute(
      //   path: '/services/:id',
      //   name: 'service-detail',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return ServiceDetailScreen(serviceId: id);
      //   },
      // ),

      // TODO: Agregar rutas de solicitudes
      // GoRoute(
      //   path: '/requests/create',
      //   name: 'create-request',
      //   builder: (context, state) => const CreateRequestScreen(),
      // ),
    ],

    // Manejo de errores
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),

        // Guards de autenticación
        redirect: (context, state) {
          final authState = ref.read(authNotifierProvider);
          final isAuthenticated = authState is Authenticated;

          final isGoingToAuth = state.matchedLocation == '/login' ||
              state.matchedLocation == '/register' ||
              state.matchedLocation == '/welcome';

          final isGoingToSplash = state.matchedLocation == '/splash';

          // Permitir splash siempre (manejará navegación internamente)
          if (isGoingToSplash) {
            return null;
          }

          // Si no está autenticado y no va a auth, redirigir a welcome
          if (!isAuthenticated && !isGoingToAuth) {
            return '/welcome';
          }

          // Si está autenticado y va a auth, redirigir a home
          if (isAuthenticated && isGoingToAuth) {
            return '/home';
          }

          return null; // Permitir navegación
        },
      );
}

/// Helper para refresh del router cuando cambia el estado de auth
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}

/// Provider del router
final goRouterProvider = Provider<GoRouter>((ref) {
  return AppRouterConfig.router(ref);
});
