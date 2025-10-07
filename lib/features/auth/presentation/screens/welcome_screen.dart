import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';

/// Pantalla de bienvenida para usuarios no autenticados
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo e ilustración
              Icon(
                Icons.handyman_rounded,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSizes.paddingLg),

              // Título
              Text(
                'Bienvenido a Recurseo',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingMd),

              // Descripción
              Text(
                'Encuentra profesionales calificados para cualquier servicio que necesites',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Botones
              ElevatedButton(
                onPressed: () {
                  // TODO: Navegar a login
                  context.go('/home');
                },
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: AppSizes.paddingMd),

              OutlinedButton(
                onPressed: () {
                  // TODO: Navegar a registro
                  context.go('/home');
                },
                child: const Text('Crear Cuenta'),
              ),
              const SizedBox(height: AppSizes.paddingMd),

              TextButton(
                onPressed: () {
                  // Continuar sin cuenta (funcionalidad limitada)
                  context.go('/home');
                },
                child: const Text('Explorar sin cuenta'),
              ),

              const SizedBox(height: AppSizes.paddingXl),
            ],
          ),
        ),
      ),
    );
  }
}
