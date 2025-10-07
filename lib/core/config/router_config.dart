import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/auth/presentation/screens/splash_screen.dart';
import 'package:recurseo/features/auth/presentation/screens/welcome_screen.dart';
import 'package:recurseo/features/services/presentation/screens/home_screen.dart';

/// Configuración de rutas de la aplicación
class AppRouterConfig {
  AppRouterConfig._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
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

      // TODO: Agregar rutas de autenticación
      // GoRoute(
      //   path: '/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginScreen(),
      // ),
      // GoRoute(
      //   path: '/register',
      //   name: 'register',
      //   builder: (context, state) => const RegisterScreen(),
      // ),

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

    // Redirección (útil para autenticación)
    redirect: (context, state) {
      // TODO: Implementar lógica de autenticación
      // final isAuthenticated = false;
      // final isGoingToAuth = state.matchedLocation.startsWith('/login') ||
      //     state.matchedLocation.startsWith('/register') ||
      //     state.matchedLocation == '/welcome';

      // if (!isAuthenticated && !isGoingToAuth) {
      //   return '/welcome';
      // }
      // if (isAuthenticated && isGoingToAuth) {
      //   return '/home';
      // }

      // Redirección temporal del splash a welcome
      if (state.matchedLocation == '/splash') {
        Future.delayed(const Duration(seconds: 2), () {
          // Aquí verificarías si hay sesión
          // Por ahora, siempre va a welcome
        });
      }

      return null; // No redirigir
    },
  );
}
