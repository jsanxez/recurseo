import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget reutilizable para mostrar opciones de contacto
/// Incluye WhatsApp, llamada telefónica y email
class ContactCard extends StatelessWidget {
  final String professionalName;
  final String? phone;
  final String? email;
  final String? preFilledMessage;

  const ContactCard({
    super.key,
    required this.professionalName,
    this.phone,
    this.email,
    this.preFilledMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Si no hay información de contacto, no mostrar nada
    if (phone == null && email == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_phone,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contactar a $professionalName',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botones de contacto
            if (phone != null) ...[
              Row(
                children: [
                  // Botón WhatsApp
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _launchWhatsApp(context),
                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366), // Verde WhatsApp
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Botón Llamar
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _launchPhone(context),
                      icon: const Icon(Icons.phone),
                      label: const Text('Llamar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Mostrar número de teléfono
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_android,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        phone!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: () => _copyToClipboard(context, phone!, 'Teléfono'),
                      tooltip: 'Copiar teléfono',
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],

            // Email
            if (email != null) ...[
              if (phone != null) const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _launchEmail(context),
                icon: const Icon(Icons.email),
                label: const Text('Enviar Email'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        email!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      onPressed: () => _copyToClipboard(context, email!, 'Email'),
                      tooltip: 'Copiar email',
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Abrir WhatsApp con mensaje pre-llenado
  Future<void> _launchWhatsApp(BuildContext context) async {
    if (phone == null) return;

    // Limpiar el número de teléfono (quitar espacios, guiones, etc.)
    final cleanPhone = phone!.replaceAll(RegExp(r'[^\d+]'), '');

    // Mensaje por defecto si no se proporciona uno
    final message = preFilledMessage ??
        'Hola $professionalName, vi tu propuesta en Recurseo y me gustaría conversar contigo.';

    // Codificar el mensaje para URL
    final encodedMessage = Uri.encodeComponent(message);

    // URL de WhatsApp con mensaje pre-llenado
    final whatsappUrl = 'https://wa.me/$cleanPhone?text=$encodedMessage';

    final uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Abrir marcador de teléfono
  Future<void> _launchPhone(BuildContext context) async {
    if (phone == null) return;

    // Limpiar el número de teléfono
    final cleanPhone = phone!.replaceAll(RegExp(r'[^\d+]'), '');

    final uri = Uri.parse('tel:$cleanPhone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el marcador'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Abrir cliente de email
  Future<void> _launchEmail(BuildContext context) async {
    if (email == null) return;

    final subject = Uri.encodeComponent('Consulta desde Recurseo');
    final body = Uri.encodeComponent(
      'Hola $professionalName,\n\nVi tu propuesta en Recurseo y me gustaría conversar contigo.\n\nSaludos,',
    );

    final uri = Uri.parse('mailto:$email?subject=$subject&body=$body');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el cliente de email'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Copiar texto al portapapeles
  Future<void> _copyToClipboard(
    BuildContext context,
    String text,
    String label,
  ) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label copiado al portapapeles'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
