import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';

/// Pantalla de bienvenida/carga inicial
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Esperar 2 segundos para mostrar el splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Verificar estado de autenticación
    final authState = ref.read(authNotifierProvider);
    final isAuthenticated = authState is Authenticated;

    // Navegar según el estado de autenticación
    if (isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o icono de la app
            const Icon(
              Icons.handyman_rounded,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Recurseo',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Conectamos profesionales con empleadores',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
