import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';

/// Pantalla de configuración de la cuenta
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          // Cuenta
          _buildSectionHeader(context, 'Cuenta'),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Cambiar contraseña'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showChangePasswordDialog(context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Cambiar email'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad próximamente'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Notificaciones
          _buildSectionHeader(context, 'Notificaciones'),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm,
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Notificaciones push'),
                  subtitle: const Text('Recibe notificaciones en tiempo real'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Guardar preferencia
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.email_outlined),
                  title: const Text('Notificaciones por email'),
                  subtitle: const Text('Recibe actualizaciones por correo'),
                  value: false,
                  onChanged: (value) {
                    // TODO: Guardar preferencia
                  },
                ),
              ],
            ),
          ),

          // Privacidad
          _buildSectionHeader(context, 'Privacidad'),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Política de privacidad'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Abrir política de privacidad
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Términos y condiciones'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Abrir términos
                  },
                ),
              ],
            ),
          ),

          // Soporte
          _buildSectionHeader(context, 'Soporte'),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Centro de ayuda'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Abrir ayuda
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.chat_outlined),
                  title: const Text('Contactar soporte'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Abrir chat de soporte
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('Reportar un problema'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Abrir form de reporte
                  },
                ),
              ],
            ),
          ),

          // Información
          _buildSectionHeader(context, 'Información'),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Acerca de Recurseo'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text('Versión'),
                  trailing: Text('0.1.0'),
                ),
              ],
            ),
          ),

          // Zona peligrosa
          _buildSectionHeader(context, 'Zona de Peligro'),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm,
            ),
            color: AppColors.error.withValues(alpha: 0.05),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: AppColors.error),
              title: const Text(
                'Eliminar cuenta',
                style: TextStyle(color: AppColors.error),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: AppColors.error),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
          ),

          const SizedBox(height: AppSizes.paddingXl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.paddingLg,
        AppSizes.paddingLg,
        AppSizes.paddingSm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: AppSizes.paddingMd),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: AppSizes.paddingMd),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar cambio de contraseña
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contraseña actualizada'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de Recurseo'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recurseo - Marketplace de Servicios'),
            SizedBox(height: AppSizes.paddingMd),
            Text('Versión: 0.1.0'),
            SizedBox(height: AppSizes.paddingSm),
            Text('Conectamos profesionales con clientes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cuenta'),
        content: const Text(
          'Esta acción es permanente y no se puede deshacer. ¿Estás seguro que deseas eliminar tu cuenta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar eliminación de cuenta
              Navigator.pop(context);
              context.go('/welcome');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
