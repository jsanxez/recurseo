import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/core/utils/validators.dart';
import 'package:recurseo/core/widgets/custom_text_field.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';

/// Pantalla de edición de perfil del usuario
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    // TODO: Implementar llamada al repositorio
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary,
                      child: user?.photoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user!.photoUrl!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.person, size: 60,
 color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              size: 18, color: Colors.white),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  // TODO: Implementar cambio de foto
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Funcionalidad próximamente'),
                                    ),
                                  );
                                },
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingXl),

              // Tipo de usuario (no editable)
              Card(
                child: ListTile(
                  leading: Icon(
                    user?.userType.name == 'provider'
                        ? Icons.work_outline
                        : Icons.person_outline,
                    color: AppColors.primary,
                  ),
                  title: const Text('Tipo de cuenta'),
                  subtitle: Text(
                    user?.userType.name == 'provider' ? 'Profesional' : 'Empleador',
                  ),
                  trailing: const Icon(Icons.lock_outline, size: 16),
                ),
              ),
              const SizedBox(height: AppSizes.paddingLg),

              // Nombre
              CustomTextField(
                controller: _nameController,
                label: 'Nombre completo',
                prefixIcon: Icons.person_outline,
                validator: (value) => Validators.required(value, 'El nombre'),
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSizes.paddingMd),

              // Email (no editable)
              CustomTextField(
                controller: TextEditingController(text: user?.email ?? ''),
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                enabled: false,
                suffixIcon: const Icon(Icons.lock_outline, size: 16),
              ),
              const SizedBox(height: AppSizes.paddingMd),

              // Teléfono
              CustomTextField(
                controller: _phoneController,
                label: 'Teléfono',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSizes.paddingXl),

              // Botón de guardar
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
