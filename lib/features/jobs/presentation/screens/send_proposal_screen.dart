import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/presentation/providers/send_proposal_provider.dart';

/// Pantalla para enviar una propuesta a una oferta de trabajo
class SendProposalScreen extends ConsumerStatefulWidget {
  final String jobId;
  final String jobTitle;

  const SendProposalScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  ConsumerState<SendProposalScreen> createState() =>
      _SendProposalScreenState();
}

class _SendProposalScreenState extends ConsumerState<SendProposalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _rateController = TextEditingController();
  final _estimatedDaysController = TextEditingController();

  String _rateType = 'por_dia';
  DateTime _availableFrom = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _messageController.dispose();
    _rateController.dispose();
    _estimatedDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(sendProposalProvider);

    // Mostrar diálogo de éxito
    ref.listen<SendProposalState>(sendProposalProvider, (previous, next) {
      if (next.isSuccess && !next.isLoading) {
        _showSuccessDialog();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Propuesta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info del trabajo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Propuesta para:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.jobTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Mensaje de presentación
              Text(
                'Mensaje de presentación *',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText:
                      'Describe tu experiencia, habilidades y por qué eres el mejor candidato para este trabajo...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El mensaje es requerido';
                  }
                  if (value.trim().length < 50) {
                    return 'El mensaje debe tener al menos 50 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tarifa propuesta
              Text(
                'Tarifa propuesta *',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _rateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        hintText: '0',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final rate = double.tryParse(value);
                        if (rate == null || rate <= 0) {
                          return 'Tarifa inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _rateType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'por_hora',
                          child: Text('Por hora'),
                        ),
                        DropdownMenuItem(
                          value: 'por_dia',
                          child: Text('Por día'),
                        ),
                        DropdownMenuItem(
                          value: 'por_proyecto',
                          child: Text('Por proyecto'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _rateType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Disponibilidad
              Text(
                'Disponible desde *',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_availableFrom.day}/${_availableFrom.month}/${_availableFrom.year}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Duración estimada (opcional)
              Text(
                'Duración estimada (días)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _estimatedDaysController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  hintText: 'Ej: 5',
                  border: OutlineInputBorder(),
                  helperText: 'Opcional - Cuántos días te tomará completar',
                ),
              ),
              const SizedBox(height: 24),

              // Información adicional
              Card(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Consejos para tu propuesta',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTip('Sé específico sobre tu experiencia relevante'),
                      _buildTip(
                          'Menciona proyectos similares que hayas completado'),
                      _buildTip('Explica por qué tu tarifa es justa'),
                      _buildTip('Sé profesional y cordial'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (state.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Botón enviar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: state.isLoading ? null : _submitProposal,
                  icon: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    state.isLoading ? 'Enviando...' : 'Enviar Propuesta',
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _availableFrom,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null) {
      setState(() {
        _availableFrom = picked;
      });
    }
  }

  void _submitProposal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final rate = double.parse(_rateController.text);
    final estimatedDays = _estimatedDaysController.text.isNotEmpty
        ? int.parse(_estimatedDaysController.text)
        : null;

    ref.read(sendProposalProvider.notifier).sendProposal(
          jobPostId: widget.jobId,
          message: _messageController.text.trim(),
          proposedRate: rate,
          rateType: _rateType,
          availableFrom: _availableFrom,
          estimatedDays: estimatedDays,
        );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        title: const Text('¡Propuesta Enviada!'),
        content: const Text(
          'Tu propuesta ha sido enviada exitosamente. El empleador la revisará y te contactará si está interesado.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Cerrar diálogo y volver
              context.pop(); // Cierra el diálogo
              context.pop(); // Vuelve a la pantalla anterior
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
