import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/core/utils/validators.dart';
import 'package:recurseo/core/widgets/custom_text_field.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';

/// Pantalla de inicio de sesión
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authNotifierProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      switch (next) {
        case Authenticated():
          // Navegar a home si login exitoso
          context.go('/home');

        case AuthError(message: final message):
          // Mostrar error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
          // Limpiar error después de mostrar
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              ref.read(authNotifierProvider.notifier).clearError();
            }
          });

        case AuthLoading():
        case Unauthenticated():
        case AuthInitial():
          break;
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Icono
                  Icon(
                    Icons.handyman_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSizes.paddingLg),

                  // Título
                  Text(
                    'Bienvenido',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.paddingSm),
                  Text(
                    'Inicia sesión para continuar',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.paddingXl),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'tu@email.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSizes.paddingMd),

                  // Contraseña
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: Validators.password,
                    enabled: !isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingMd),

                  // ¿Olvidaste tu contraseña?
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // TODO: Implementar reset password
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Funcionalidad próximamente'),
                                ),
                              );
                            },
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingMd),

                  // Botón de Login
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(height: AppSizes.paddingLg),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingMd,
                        ),
                        child: Text(
                          'o',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingLg),

                  // Crear cuenta
                  OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.push('/register');
                          },
                    child: const Text('Crear Cuenta Nueva'),
                  ),
                  const SizedBox(height: AppSizes.paddingMd),

                  // Volver
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.go('/welcome');
                          },
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
