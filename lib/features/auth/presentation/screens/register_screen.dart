import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/core/utils/validators.dart';
import 'package:recurseo/core/widgets/custom_text_field.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';

/// Pantalla de registro de nuevo usuario
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserType _selectedUserType = UserType.client;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authNotifierProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
            userType: _selectedUserType,
            phoneNumber: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      switch (next) {
        case Authenticated():
          context.go('/home');

        case AuthError(message: final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isLoading ? null : () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                Text(
                  'Crear Cuenta',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSizes.paddingSm),
                Text(
                  'Completa tus datos para registrarte',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSizes.paddingXl),

                // Tipo de usuario
                Text(
                  '¿Cómo te gustaría usar Recurseo?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSizes.paddingMd),

                Row(
                  children: [
                    Expanded(
                      child: _UserTypeCard(
                        title: 'Empleador',
                        description: 'Necesito contratar',
                        icon: Icons.person_outline,
                        isSelected: _selectedUserType == UserType.client,
                        onTap: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _selectedUserType = UserType.client;
                                });
                              },
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingMd),
                    Expanded(
                      child: _UserTypeCard(
                        title: 'Profesional',
                        description: 'Ofrezco servicios',
                        icon: Icons.work_outline,
                        isSelected: _selectedUserType == UserType.provider,
                        onTap: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _selectedUserType = UserType.provider;
                                });
                              },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingLg),

                // Nombre completo
                CustomTextField(
                  controller: _nameController,
                  label: 'Nombre completo',
                  hint: 'Juan Pérez',
                  prefixIcon: Icons.person_outline,
                  validator: (value) => Validators.required(value, 'El nombre'),
                  enabled: !isLoading,
                ),
                const SizedBox(height: AppSizes.paddingMd),

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

                // Teléfono (opcional)
                CustomTextField(
                  controller: _phoneController,
                  label: 'Teléfono (opcional)',
                  hint: '+521234567890',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
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

                // Confirmar contraseña
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar contraseña',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  enabled: !isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXl),

                // Botón de registro
                ElevatedButton(
                  onPressed: isLoading ? null : _handleRegister,
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
                      : const Text('Crear Cuenta'),
                ),
                const SizedBox(height: AppSizes.paddingMd),

                // Ya tienes cuenta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.go('/login');
                            },
                      child: const Text('Inicia Sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget para seleccionar tipo de usuario
class _UserTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const _UserTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            children: [
              Icon(
                icon,
                size: AppSizes.iconXl,
                color: isSelected ? AppColors.primary : AppColors.grey500,
              ),
              const SizedBox(height: AppSizes.paddingSm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppColors.primary : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
              ),
              const SizedBox(height: AppSizes.paddingXs),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
